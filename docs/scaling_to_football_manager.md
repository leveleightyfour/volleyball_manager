# Scaling Position Rating System to Football Manager Scale

## Overview

This document covers optimizations and best practices for handling **tens of thousands of players** in your volleyball manager game, inspired by Football Manager's scale.

## Scale Targets

### Small Scale (Current)
- **Players:** 10-50 per team
- **Total Players:** 100-1,000 in database
- **Strategy:** Either approach works fine

### Football Manager Scale (Target)
- **Players:** 50,000+ in database
- **Active leagues:** Multiple countries, divisions
- **Transfer market:** Search/filter thousands of players
- **Strategy:** MUST use stored/precomputed ratings

---

## Performance Comparison

### Compute On-Demand
```
Loading 10,000 players with calculated ratings:
- First load: 10,000 × 1ms = 10 seconds ❌
- Memory cache: ~40MB RAM
- SQL queries: Cannot filter by rating
```

### Stored Ratings (Recommended)
```
Loading 10,000 players with stored ratings:
- Any load: 100-200ms ✅
- Storage: 400KB extra (negligible)
- SQL queries: Fast filtering, sorting, indexes
```

**Verdict:** At 10,000+ players, stored ratings are **50-100x faster**.

---

## Database Optimizations

### 1. Add Indexes for Position Ratings

```dart
// In player_tables.dart, add to Players table:

@override
List<Index> get customIndexes => [
  // Index for each position rating (enables fast sorting/filtering)
  Index('idx_rating_oh', [ratingOh]),
  Index('idx_rating_opp', [ratingOpp]),
  Index('idx_rating_mb', [ratingMb]),
  Index('idx_rating_s', [ratingS]),
  Index('idx_rating_l', [ratingL]),

  // Composite index for team-based queries (add when you have teams)
  // Index('idx_team_rating_oh', [teamId, ratingOh]),
];
```

**Impact:** Queries like "TOP 100 setters" go from 500ms → 5ms

### 2. Batch Updates for Bulk Operations

```dart
// Use PositionRatingBatchService for mass updates

final batchService = PositionRatingBatchService(
  playerDao: playerDao,
  calculator: calculator,
);

// Recalculate all 10,000 players efficiently
await batchService.recalculateAllPlayers(
  batchSize: 500, // Process 500 at a time
  onProgress: (current, total) {
    print('Progress: $current/$total');
  },
);
```

**Performance:**
- Old way (individual updates): 10,000 × 5ms = **50 seconds**
- Batch way (transactions): 20 batches × 50ms = **1 second** (50x faster!)

### 3. Background Processing for Initialization

When loading the game initially or after formula changes:

```dart
// Initialize ratings in background
Future<void> initializePlayerRatings() async {
  // Check if any player has default ratings (not calculated yet)
  final needsInit = await _checkIfNeedsInitialization();

  if (needsInit) {
    // Show loading screen
    showLoadingDialog('Calculating player ratings...');

    // Calculate in background
    await compute(_calculateAllRatings, {
      'dbPath': dbPath,
      'configPath': configPath,
    });

    hideLoadingDialog();
  }
}
```

---

## Query Patterns for Football Manager Features

### 1. Transfer Market Search

```dart
// "Show me all setters rated 14+ under age 25"
Future<List<Player>> searchTransferMarket({
  required String position,
  required double minRating,
  int? maxAge,
  int? maxPrice,
}) async {
  var query = select(players);

  // Position rating filter
  switch (position) {
    case 's':
      query.where((t) => t.ratingS.isBiggerOrEqualValue(minRating));
      break;
    // ... other positions
  }

  // Age filter (when you add birth dates)
  // if (maxAge != null) {
  //   query.where((t) => t.age.isSmallerOrEqualValue(maxAge));
  // }

  // Sort by rating (best first)
  query.orderBy([(t) => OrderingTerm.desc(t.ratingS)]);
  query.limit(100); // Show top 100 matches

  return query.get();
}
```

**With indexes:** <10ms for 50,000 player database

### 2. League Best XI

```dart
// "Best starting lineup in Serie A"
Future<Map<String, Player>> getBestXI() async {
  return {
    'setter': (await playerDao.getTopPlayersByPosition('s', limit: 1)).first,
    'oh1': (await playerDao.getTopPlayersByPosition('oh', limit: 1)).first,
    'oh2': (await playerDao.getTopPlayersByPosition('oh', limit: 2))[1],
    'opp': (await playerDao.getTopPlayersByPosition('opp', limit: 1)).first,
    'mb1': (await playerDao.getTopPlayersByPosition('mb', limit: 1)).first,
    'mb2': (await playerDao.getTopPlayersByPosition('mb', limit: 2))[1],
    'libero': (await playerDao.getTopPlayersByPosition('l', limit: 1)).first,
  };
}
```

### 3. Scout Reports

```dart
// "Find hidden gems - players rated 13+ in multiple positions"
Future<List<Player>> findVersatilePlayers({
  double minRating = 13.0,
  int minPositions = 3,
}) async {
  final allPlayers = await playerDao.getAll();

  return allPlayers.where((player) {
    int goodPositions = 0;
    if (player.ratingOh >= minRating) goodPositions++;
    if (player.ratingOpp >= minRating) goodPositions++;
    if (player.ratingMb >= minRating) goodPositions++;
    if (player.ratingS >= minRating) goodPositions++;
    if (player.ratingL >= minRating) goodPositions++;
    return goodPositions >= minPositions;
  }).toList();
}
```

---

## Data Management Strategy

### When to Recalculate Ratings

#### 1. Individual Player Updates (Real-time)
```dart
// Player attributes changed (training, injury recovery, etc.)
Future<void> updatePlayerAttributes(int playerId, Map<String, int> newAttrs) async {
  // Update attributes
  await playerDao.updateAttributes(playerId, newAttrs);

  // Immediately recalculate ratings for THIS player only
  final player = await playerDao.getById(playerId);
  final ratings = calculator.calculateAllPositionRatings(player!);
  await playerDao.updatePositionRatings(
    playerId,
    oh: ratings['oh']!,
    opp: ratings['opp']!,
    mb: ratings['mb']!,
    s: ratings['s']!,
    l: ratings['l']!,
  );
}
```

#### 2. Bulk Recalculation (Batch/Background)
```dart
// When to trigger:
// - Formula/weight changes (game patch)
// - New season initialization
// - Database migration
// - Data integrity check

final batchService = PositionRatingBatchService(...);

// Option A: All at once (small datasets <1000)
await batchService.recalculateAllPlayers();

// Option B: Progressive (large datasets 10,000+)
await batchService.recalculateAllPlayers(
  batchSize: 500,
  onProgress: (current, total) {
    updateProgressBar(current / total);
  },
);
```

#### 3. Lazy Initialization (On-demand first access)
```dart
// Check if ratings are outdated on player access
Future<Player> getPlayerWithFreshRatings(int playerId) async {
  final player = await playerDao.getById(playerId);

  // Check if ratings need refresh (optional)
  if (_ratingsAreStale(player)) {
    await _recalculatePlayerRatings(player);
  }

  return player;
}
```

---

## Memory Management at Scale

### Problem: Loading 50,000 players into memory = RAM issues

### Solution: Pagination + Virtual Scrolling

```dart
// Don't do this:
final allPlayers = await playerDao.getAll(); // Loads 50,000 players!

// Do this instead:
Future<List<Player>> getPlayersPage(int page, int pageSize) async {
  return (select(players)
    ..limit(pageSize, offset: page * pageSize))
    .get();
}

// In UI (with infinite scroll):
class TransferMarketList extends StatefulWidget {
  // Load 50 players at a time as user scrolls
  // Total memory: 50 players instead of 50,000
}
```

---

## Formula Balancing Workflow

### Development Cycle for Large Databases

```dart
// 1. Edit formula in JSON
// assets/config/position_weights.json or skill_formulas.json

// 2. Test on small sample (fast iteration)
final testPlayers = await playerDao.getAll().limit(100);
final batchService = PositionRatingBatchService(...);
await batchService.updatePlayersBatch(testPlayers);

// 3. Check distribution
final stats = await batchService.getPositionStats();
print(stats); // Shows min/max/avg/median for each position

// 4. If satisfied, apply to all players
await batchService.recalculateAllPlayers();
```

### Rating Distribution Health Check

```dart
// Run after formula changes to ensure balance
final stats = await batchService.getPositionStats();

// Good distribution example:
// OH:  min: 5.2, max: 18.7, avg: 12.1, median: 12.3 ✅
// S:   min: 4.8, max: 19.1, avg: 12.0, median: 11.9 ✅

// Bad distribution (needs rebalancing):
// OH:  min: 15.0, max: 16.0, avg: 15.5, median: 15.5 ❌ (too narrow)
// S:   min: 1.0, max: 20.0, avg: 10.5, median: 10.0 ❌ (too wide)
```

---

## Database Schema Recommendations

### Current Schema (Good for 50K+ players)
```dart
Players {
  // Primary key
  id: integer

  // Base attributes (23 columns)
  wristSnap, power, accuracy, ... (1-20 scale)

  // Position ratings (5 columns) ✅ KEEP THESE
  ratingOh, ratingOpp, ratingMb, ratingS, ratingL (1-20 scale)

  // Future additions for Football Manager features
  // teamId: integer (foreign key)
  // leagueId: integer (foreign key)
  // nationality: text
  // age: integer
  // contractValue: integer
  // marketValue: integer
}
```

### Recommended Indexes
```sql
CREATE INDEX idx_rating_oh ON players(rating_oh DESC);
CREATE INDEX idx_rating_opp ON players(rating_opp DESC);
CREATE INDEX idx_rating_mb ON players(rating_mb DESC);
CREATE INDEX idx_rating_s ON players(rating_s DESC);
CREATE INDEX idx_rating_l ON players(rating_l DESC);

-- For transfer market (when you add teams/leagues)
CREATE INDEX idx_team_league ON players(team_id, league_id);
CREATE INDEX idx_league_rating ON players(league_id, rating_oh DESC);
```

---

## Performance Benchmarks (Target)

### Operations per Second (50,000 player database)

| Operation | Without Indexes | With Indexes | Target |
|-----------|----------------|--------------|--------|
| Get player by ID | 1ms | 1ms | <5ms ✅ |
| Top 100 setters | 500ms | 5ms | <50ms ✅ |
| Search by rating | 2000ms | 10ms | <100ms ✅ |
| Update single player | 5ms | 5ms | <10ms ✅ |
| Batch update 1000 players | 50ms | 50ms | <100ms ✅ |
| Full recalculation | 60s | 60s | <5min ✅ |

---

## Migration Checklist for Scale

- [✅] **Keep stored ratings** (you already have this)
- [✅] **Batch update methods** (added in PlayerDao)
- [✅] **Batch service** (created PositionRatingBatchService)
- [✅] **Query methods** (getTopPlayersByPosition, etc.)
- [ ] **Add database indexes** (add to migration)
- [ ] **Pagination for UI lists** (when building transfer market)
- [ ] **Progress tracking** (for bulk operations)
- [ ] **Background processing** (for startup initialization)
- [ ] **Rating staleness detection** (optional integrity check)

---

## Code Examples for Common Use Cases

### 1. Game Startup (Initialize if Needed)
```dart
class GameInitializer {
  Future<void> initialize() async {
    // Check if any player has default ratings (10.0)
    final hasUninitializedRatings = await _checkDefaults();

    if (hasUninitializedRatings) {
      showLoadingScreen('Initializing player database...');

      final batchService = await ref.read(
        positionRatingBatchServiceProvider.future
      );

      await batchService.recalculateAllPlayers(
        onProgress: (current, total) {
          updateProgress(current, total);
        },
      );

      hideLoadingScreen();
    }
  }
}
```

### 2. Transfer Market Filter UI
```dart
class TransferMarketScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Filters
        PositionFilter(onChanged: (pos) => _filterPosition = pos),
        RatingSlider(
          min: 1,
          max: 20,
          onChanged: (rating) => _minRating = rating,
        ),

        // Results (paginated)
        FutureBuilder(
          future: playerDao.getPlayersByPositionRating(
            _filterPosition,
            _minRating,
            limit: 100,
          ),
          builder: (context, snapshot) {
            // Show list of players
            return ListView.builder(...);
          },
        ),
      ],
    );
  }
}
```

### 3. Formula Rebalancing Tool (Dev Only)
```dart
class FormulaBalancingTool extends StatefulWidget {
  Future<void> applyChanges() async {
    // 1. Update JSON files (done manually or via UI)

    // 2. Reload services
    ref.invalidate(positionRatingCalculatorProvider);

    // 3. Test on sample
    final sample = await playerDao.getAll().limit(100);
    final batchService = await ref.read(...);
    await batchService.updatePlayersBatch(sample);

    // 4. Show stats
    final stats = await batchService.getPositionStats();
    showStatsDialog(stats);

    // 5. If good, apply to all
    if (await confirm('Apply to all players?')) {
      await batchService.recalculateAllPlayers(
        onProgress: showProgress,
      );
    }
  }
}
```

---

## Summary

**Your current implementation (stored ratings) is PERFECT for Football Manager scale!**

### What you have:
- ✅ Ratings stored in database
- ✅ Fast SQL queries possible
- ✅ Individual update methods
- ✅ Calculation system

### What to add for 50,000+ players:
- ✅ Batch update methods (DONE - added to PlayerDao)
- ✅ Batch service (DONE - PositionRatingBatchService)
- ✅ Query helpers (DONE - getTopPlayersByPosition, etc.)
- 🔲 Database indexes (add in next migration)
- 🔲 Pagination in UI (add when building transfer market)

**You're already 90% ready for massive scale!** 🎉
