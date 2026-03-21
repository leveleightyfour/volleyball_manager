# Position Rating System

## Overview

The Position Rating System dynamically calculates how suitable each player is for every volleyball position (Outside Hitter, Opposite, Middle Blocker, Setter, Libero) based on their individual attributes and skills.

## Key Concepts

### Dynamic Rating Calculation
Instead of assigning players to fixed positions, the system calculates a **1-20 rating** for each position based on:
1. The player's 23 base attributes (serving, setting, blocking, reception, attack, defense)
2. How those attributes combine into specific skills (via skill formulas)
3. Which skills are most important for each position (via position weights)

### Example
A player with high `vision`, `timing`, `power`, and `versatility` attributes will:
- Score high on `attackOutsideTempo` and `attackOutsideHigh` skills
- Get a strong **Outside Hitter** rating (since those skills are weighted heavily for OH)
- May score lower for **Setter** (which emphasizes different skills)

## Architecture

### 1. Configuration Files

#### `assets/config/position_weights.json`
Defines which skills matter for each position and how much they contribute:

```json
{
  "oh": {
    "positionName": "Outside Hitter",
    "skillWeights": {
      "attackOutsideTempo": 0.20,    // 20% of OH rating
      "attackOutsideHigh": 0.15,      // 15% of OH rating
      "receptionJumpServe": 0.15,     // etc.
      ...
    }
  },
  ...
}
```

Weights for each position sum to 1.0 (100%).

### 2. Core Classes

#### `PositionRatingCalculator`
[lib/features/player/domain/position_rating_calculator.dart](lib/features/player/domain/position_rating_calculator.dart)

**Responsibilities:**
- Calculate position ratings using skill values and position weights
- Identify a player's best position
- Rank all positions for a player
- Check if a player is suitable for a position (threshold-based)

**Key Methods:**
```dart
// Calculate rating for a specific position (1-20 scale)
double calculatePositionRating(String position, Player player)

// Calculate all position ratings
Map<String, double> calculateAllPositionRatings(Player player)

// Get best position
MapEntry<String, double> getBestPosition(Player player)

// Get ranked positions (best to worst)
List<MapEntry<String, double>> getRankedPositions(Player player)
```

#### `PositionRatingService`
[lib/features/player/domain/position_rating_service.dart](lib/features/player/domain/position_rating_service.dart)

**Responsibilities:**
- Manage position rating lifecycle (initialize, calculate, persist)
- Interface with database to store/retrieve ratings
- Provide convenience methods for getting player position info

**Key Methods:**
```dart
// Must be called before use
Future<void> initialize()

// Calculate and save ratings to database
Future<void> updatePlayerRatings(Player player)
Future<void> updateAllPlayerRatings()

// Get saved ratings from database
Future<Map<String, double>> getPlayerRatings(int playerId)
Future<MapEntry<String, double>> getBestPosition(int playerId)
```

### 3. Database Integration

#### Player Table Columns
[lib/features/player/data/local/player_tables.dart](lib/features/player/data/local/player_tables.dart)

New columns added to store calculated ratings:
```dart
RealColumn get ratingOh => real().withDefault(const Constant(10.0))();
RealColumn get ratingOpp => real().withDefault(const Constant(10.0))();
RealColumn get ratingMb => real().withDefault(const Constant(10.0))();
RealColumn get ratingS => real().withDefault(const Constant(10.0))();
RealColumn get ratingL => real().withDefault(const Constant(10.0))();
```

#### PlayerDao Methods
[lib/features/player/data/local/player_dao.dart](lib/features/player/data/local/player_dao.dart)

```dart
Future<bool> updatePositionRatings(
  int id, {
  required double oh,
  required double opp,
  required double mb,
  required double s,
  required double l,
})
```

### 4. Riverpod Providers

[lib/features/player/domain/position_rating_providers.dart](lib/features/player/domain/position_rating_providers.dart)

Available providers:
- `positionWeightsProvider` - Position weight configurations
- `skillCalculatorProvider` - Skill calculator instance
- `positionRatingCalculatorProvider` - Position rating calculator
- `positionRatingServiceProvider` - Position rating service
- `playerPositionRatingsProvider(playerId)` - Get all ratings for a player
- `playerBestPositionProvider(playerId)` - Get best position for a player
- `playerRankedPositionsProvider(playerId)` - Get ranked positions for a player

## Usage Examples

### Example 1: Calculate Ratings for a New Player

```dart
// When creating/updating a player
final service = await ref.read(positionRatingServiceProvider.future);
await service.updatePlayerRatings(player);
```

### Example 2: Display Player's Best Position

```dart
// In a widget
final bestPosition = await ref.watch(
  playerBestPositionProvider(playerId).future
);

print('Best position: ${bestPosition.key} (${bestPosition.value.toStringAsFixed(1)})');
// Output: "Best position: oh (15.3)"
```

### Example 3: Show All Position Ratings

```dart
final ratings = await ref.watch(
  playerPositionRatingsProvider(playerId).future
);

for (final entry in ratings.entries) {
  print('${entry.key}: ${entry.value.toStringAsFixed(1)}');
}
// Output:
// oh: 15.3
// opp: 14.8
// mb: 12.1
// s: 10.5
// l: 13.2
```

### Example 4: Get Position Name

```dart
final service = await ref.read(positionRatingServiceProvider.future);
final name = service.getPositionName('oh'); // "Outside Hitter"
```

## Rating Formula

The position rating is calculated as:

```
Position Rating = Σ (skill_value × skill_weight)
```

Where:
- `skill_value` comes from `SkillCalculator` (based on player attributes)
- `skill_weight` comes from position configuration
- Sum is over all skills defined for that position

Since:
- Player attributes are on a 1-20 scale
- Skill weights sum to 1.0
- Skills are weighted averages of attributes

The resulting position rating naturally falls on a 1-20 scale.

## Position Definitions

### Outside Hitter (OH)
- **Focus:** Attacking (tempo + high balls), passing, all-around play
- **Key Skills:** Attack outside tempo/high, reception, defending, blocking
- **Attribute Emphasis:** Vision, power, platform, footwork

### Opposite Hitter (OPP)
- **Focus:** Right-side attacking, blocking, serving power
- **Key Skills:** Attack outside tempo/high, block middle/right, serve power
- **Attribute Emphasis:** Power, vision, height, penetration, wrist snap

### Middle Blocker (MB)
- **Focus:** Quick attacks, primary blocking, court coverage
- **Key Skills:** Block all positions, attack middle
- **Attribute Emphasis:** Height, timing, penetration, anticipation

### Setter (S)
- **Focus:** Playmaking, ball distribution
- **Key Skills:** All setting variations (tempo, high, middle, back row)
- **Attribute Emphasis:** Positioning, predictability, creativity, strength

### Libero (L)
- **Focus:** Defensive specialist (passing and digging)
- **Key Skills:** Reception (all serve types), defending all attacks
- **Attribute Emphasis:** Platform, footwork, touch, reaction, reading

## Testing

Tests are located at:
[test/features/player/domain/position_rating_calculator_test.dart](test/features/player/domain/position_rating_calculator_test.dart)

Run tests with:
```bash
flutter test test/features/player/domain/position_rating_calculator_test.dart
```

## Future Enhancements

### Potential Additions:
1. **Position Chemistry** - Bonus ratings when players complement each other
2. **Role Variants** - Specialized roles (defensive OH, offensive setter, etc.)
3. **Training Impact** - Track how training affects position suitability over time
4. **Match Performance** - Adjust ratings based on actual match performance
5. **Position Versatility Score** - How well a player can play multiple positions
6. **Fatigue Modifiers** - Adjust ratings based on player fitness/fatigue

### Configuration:
- All position weights can be tuned via JSON without code changes
- Easy to add new positions or adjust existing weights
- Weights should sum to 1.0 for each position

## Notes

- Position ratings are **cached in the database** for performance
- Ratings should be **recalculated** when:
  - Player attributes change
  - Skill formulas are updated
  - Position weight configurations change
- The system is **fully dynamic** - no hard-coded position assignments
- Players can be evaluated for **any position** regardless of their "natural" position
