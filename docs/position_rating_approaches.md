# Position Rating Calculation: Architecture Decision

## The Question
Should we **compute ratings on-demand** or **precompute and store** them in the database?

## TL;DR Recommendation

**For your volleyball manager game, I recommend: Compute on-demand (Hybrid Approach)**

Why? Your use case has:
- Infrequent attribute changes (only during player editing/training)
- Frequent rating reads (viewing rosters, lineups, player cards)
- Small player counts (typically 12-20 players per team)
- Need for formula flexibility (game balancing)

The hybrid approach with Riverpod caching gives you the best of both worlds.

---

## Detailed Comparison

### Approach 1: Precompute and Store (Current Implementation)

**How it works:**
```dart
// Database has rating columns
Player {
  // Base attributes (23)
  int wristSnap, power, accuracy, ...

  // Stored ratings (5) ← These are saved in DB
  double ratingOh, ratingOpp, ratingMb, ratingS, ratingL
}

// Update ratings when attributes change
await playerDao.updatePositionRatings(playerId, ...);

// Read is fast (already calculated)
final ratings = player.ratingOh; // Direct DB read
```

**Pros:**
- ⚡ **Blazing fast reads** - No calculation overhead
- 📊 **SQL queries possible** - Can sort/filter by rating in database
- 🎯 **Good for large datasets** - Scales well with 1000+ players
- 🔄 **Predictable performance** - Same speed every time

**Cons:**
- 💾 **Extra storage** - 5 additional columns per player
- 🐛 **Stale data risk** - Ratings can be out of sync if not updated properly
- 🔧 **Schema migrations** - Adding new positions requires DB migration
- 📝 **More code** - Need update logic, database columns, DAOs

**Best for:**
- Large rosters (100+ players)
- Need to sort/filter by position rating in SQL
- Position formulas rarely change
- Mobile apps with limited CPU

---

### Approach 2: Compute On-Demand with Caching (Hybrid - Recommended)

**How it works:**
```dart
// Database has ONLY base attributes
Player {
  // Base attributes only (23)
  int wristSnap, power, accuracy, ...
  // No rating columns!
}

// Calculate fresh every time, but cache in memory
@riverpod
Future<Map<String, double>> playerPositionRatings(Ref ref, int playerId) {
  final calculator = ref.watch(positionRatingCalculatorProvider);
  final player = ref.watch(playerProvider(playerId));
  return calculator.calculateAllPositionRatings(player); // ← Computed
}

// Riverpod caches the result in memory
final ratings = ref.watch(playerPositionRatingsProvider(1));
```

**Pros:**
- ✅ **Always accurate** - Zero risk of stale data
- 🎯 **Simpler schema** - Only store what's essential
- 🔄 **Easy formula changes** - Just update JSON, no migration
- 🧹 **Less code** - No update logic needed
- 🚀 **Auto-invalidation** - Riverpod refreshes when player changes

**Cons:**
- 🐌 **Slower first read** - Must calculate on first access
- ❌ **No SQL filtering** - Can't query "all players rated >15 for OH"
- 💻 **CPU usage** - Recalculates on every app restart
- 📦 **Memory overhead** - Riverpod cache grows with active players

**Best for:**
- Small to medium rosters (10-100 players)
- Formulas change frequently (game balancing)
- Desktop/web apps with good CPU
- Development phase (easier iteration)

---

## Specific to Your Game

### Your Usage Patterns

```dart
// Scenario 1: Viewing player card (1 player)
// Hybrid: Calculate once, cache ✅
// Stored: Read from DB ✅

// Scenario 2: Roster list (15 players)
// Hybrid: Calculate 15 times first load, then cached ⚠️
// Stored: Read 15 rows from DB ✅

// Scenario 3: Player attribute changes
// Hybrid: Auto-recalculates next access ✅
// Stored: Must remember to update ratings ⚠️

// Scenario 4: Formula balancing (dev)
// Hybrid: Just reload app ✅
// Stored: Must recalculate all players, DB migration ❌

// Scenario 5: Sort roster by OH rating
// Hybrid: Load all, sort in memory ⚠️
// Stored: SQL ORDER BY ✅
```

### Performance Math

**Calculation cost:**
- 5 positions × ~10 skills each × 4 attributes = ~200 multiplications
- On modern device: **<1ms per player**

**Cache benefits:**
- First load (15 players): ~15ms calculation
- Subsequent access: 0ms (cached)
- After attribute change: Recalculate only that player

**Verdict:** With only 15-20 players per team, compute-on-demand is **perfectly fast**.

---

## Migration Path

### Option A: Keep Current (Stored) Approach
**When to use:**
- You plan to have 100+ players in your database
- You need SQL queries like "TOP 10 setters by rating"
- Mobile-first with battery concerns
- Formula stability is high

**What to add:**
```dart
// Add auto-update triggers
Future<bool> updatePlayerAttributes(...) {
  await playerDao.updateAttributes(...);
  await updatePositionRatings(playerId); // ← Always update together
}

// Add bulk recalculation for formula changes
Future<void> recalculateAllRatings() async {
  final service = await ref.read(positionRatingServiceProvider.future);
  await service.updateAllPlayerRatings();
}
```

### Option B: Switch to Hybrid Approach
**When to use:**
- You want simpler code and DB schema
- Formula tuning is frequent (balancing gameplay)
- Desktop/web platform
- Development/iteration speed is priority

**Migration steps:**
1. Remove rating columns from `Players` table
2. Delete `PositionRatingService` (no longer needed)
3. Use `position_rating_providers_v2.dart` instead
4. Run DB migration to drop columns

---

## My Specific Recommendation for You

**Use the Hybrid Approach (Compute On-Demand) because:**

1. **You're actively balancing** - Based on your screenshot showing detailed position stats, you're fine-tuning formulas. Hybrid makes this much easier.

2. **Small player counts** - Volleyball teams have 12-14 players. Even with multiple teams (say 10 teams = 140 players), calculation cost is negligible.

3. **Desktop development** - If you're developing on desktop, CPU is not a concern.

4. **Simplicity** - Less code to maintain, fewer bugs, clearer data flow.

5. **Future flexibility** - Easy to add new positions (Beach Volleyball? 6-person variations?) without migrations.

### Implementation Plan

If you want to switch to hybrid:

```bash
# 1. Create migration to remove rating columns
# 2. Replace providers file
mv lib/features/player/domain/position_rating_providers_v2.dart \
   lib/features/player/domain/position_rating_providers.dart

# 3. Delete old service (no longer needed)
rm lib/features/player/domain/position_rating_service.dart

# 4. Regenerate
dart run build_runner build --delete-conflicting-outputs

# 5. Update any UI code to use providers instead of DB columns
```

---

## When to Reconsider

**Switch to stored approach if:**
- You add a "Transfer Market" with 1000+ players to browse
- You need to query "Find all available OH with rating >16"
- You ship to mobile and get battery drain reports
- You want roster sorting by position rating

**But even then**, consider a **hybrid-hybrid**:
- Compute on-demand for YOUR teams (small, frequently changing)
- Precompute for TRANSFER MARKET (large, infrequently changing)

---

## Code Size Comparison

### Stored Approach
```
Database columns:       28 (23 attributes + 5 ratings)
Service class:          ~140 lines
DAO methods:            ~15 lines
Providers:              ~100 lines
Update logic:           ~50 lines
Total:                  ~305 lines + 5 DB columns
```

### Hybrid Approach
```
Database columns:       23 (attributes only)
Service class:          DELETED
DAO methods:            DELETED
Providers:              ~180 lines (with batch helpers)
Update logic:           NONE (automatic)
Total:                  ~180 lines, 0 extra DB columns
```

**You save:** ~125 lines of code + simpler schema

---

## Final Verdict

For a volleyball manager game in active development:

**Go with Hybrid Approach** ✅

You can always switch to stored later if you need to scale, but starting hybrid gives you:
- Faster iteration during development
- Simpler codebase
- No stale data bugs
- Easy formula balancing

The performance difference is negligible for your use case, and the developer experience is much better.
