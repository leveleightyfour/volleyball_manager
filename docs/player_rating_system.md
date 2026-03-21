# Player Rating System Design

## Overview
Players have **user-facing attributes** (1-20 scale) that combine to create **derived skill values** for specific game actions.

## User-Facing Attributes (Base Ratings 1-20)

### Physical Attributes
- **Wrist Snap** (18)
- **Power** (20)
- **Accuracy** (11)
- **Aggression** (11)
- **Strength** (13)
- **Positioning** (17)
- **Predictability** (17)
- **Creativity** (15)
- **Penetration** (15)
- **Height** (20)
- **Form** (20)
- **Anticipation** (18)
- **Footwork** (10)
- **Platform** (17)
- **Stability** (19)
- **Touch** (11)
- **Vision** (15)
- **Timing** (15)
- **Versatility** (15)
- **Reaction** (18)
- **Reading** (15)
- **Intention** (11)
- **Control** (10)

## Derived Skill Values (Calculated)

### Serving Skills
| Ability | Formula | Example |
|---------|---------|---------|
| **Serve a Jump Serve** | 40% WristSnap + 40% Power + 10% Accuracy + 10% Aggression | 17.4 |
| **Serve a Jump Float Serve** | 10% WristSnap + 10% Power + 40% Accuracy + 40% Aggression | 12.6 |
| **Reliability (! Error %)** | Inverse of error rate | - |

### Setting Skills
| Ability | Formula | Example |
|---------|---------|---------|
| **Set the Outside Tempo** | 10% Strength + 15% Positioning + 40% Predictability + 25% Creativity | 10.8 |
| **Set the Middle** | 5% Strength + 5% Positioning + 50% Predictability + 50% Creativity | 12.0 |
| **Set the Back Row** | 10% Strength + 25% Positioning + 25% Predictability + 40% Creativity | 12.3 |
| **Set the Outside Tempo** | 10% Strength + 40% Positioning + 5% Predictability + 5% Creativity | 11.2 |
| **Consistency (Error %)** | Inverse of error rate | - |

### Blocking Skills
| Ability | Formula | Example |
|---------|---------|---------|
| **Outside Block High Ball Attack** | 10% Penetration + 40% Height + 30% Form + 20% Anticipation | 14.2 |
| **Outside Block Tempo Attack** | 20% Penetration + 30% Height + 40% Form + 10% Anticipation | 11.7 |
| **Block Middle Attack** | 40% Penetration + 10% Height + 20% Form + 30% Anticipation | 16.3 |
| **Block RH Attack** | 30% Penetration + 20% Height + 10% Form + 40% Anticipation | 16.8 |
| **Discipline (Error %)** | Inverse of error rate | - |

### Reception Skills
| Ability | Formula | Example |
|---------|---------|---------|
| **Reception from Jump Serve** | 10% Footwork + 50% Platform + 35% Stability + 15% Touch | 17.8 |
| **Reception from Jump Float Serve** | 35% Footwork + 15% Platform + 5% Stability + 45% Touch | 12.0 |

### Attack Skills
| Ability | Formula | Example |
|---------|---------|---------|
| **Attack an Outside Tempo Ball** | 40% Vision + 15% Timing + 15% Power + 30% Versatility | 15.0 |
| **Attack a Middle Ball** | 10% Vision + 50% Timing + 25% Power + 15% Versatility | 15.0 |
| **Attack an Back Row Ball** | 15% Vision + 35% Timing + 15% Power + 35% Versatility | 15.0 |
| **Attack an Outside High Ball** | 30% Vision + 5% Timing + 50% Power + 25% Versatility | 15.5 |

### Defense Skills
| Ability | Formula | Example |
|---------|---------|---------|
| **Defend an Outside Tempo attack** | 40% Reaction + 5% Reading + 25% Intention + 30% Control | 13.7 |
| **Defend a Middle attack** | 50% Reaction + 10% Reading + 10% Intention + 30% Control | 15.1 |
| **Defend a Back Row attack** | 30% Reaction + 20% Reading + 20% Intention + 30% Control | 13.6 |
| **Defend an Outside High attack** | 20% Reaction + 20% Reading + 30% Intention + 30% Control | 12.5 |

## Implementation Plan

### 1. Database Schema (Drift)

```dart
@DataClassName('Player')
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();

  // Physical Attributes (1-20)
  IntColumn get wristSnap => integer().withDefault(const Constant(10))();
  IntColumn get power => integer().withDefault(const Constant(10))();
  IntColumn get accuracy => integer().withDefault(const Constant(10))();
  IntColumn get aggression => integer().withDefault(const Constant(10))();
  IntColumn get strength => integer().withDefault(const Constant(10))();
  IntColumn get positioning => integer().withDefault(const Constant(10))();
  IntColumn get predictability => integer().withDefault(const Constant(10))();
  IntColumn get creativity => integer().withDefault(const Constant(10))();
  IntColumn get penetration => integer().withDefault(const Constant(10))();
  IntColumn get height => integer().withDefault(const Constant(10))();
  IntColumn get form => integer().withDefault(const Constant(10))();
  IntColumn get anticipation => integer().withDefault(const Constant(10))();
  IntColumn get footwork => integer().withDefault(const Constant(10))();
  IntColumn get platform => integer().withDefault(const Constant(10))();
  IntColumn get stability => integer().withDefault(const Constant(10))();
  IntColumn get touch => integer().withDefault(const Constant(10))();
  IntColumn get vision => integer().withDefault(const Constant(10))();
  IntColumn get timing => integer().withDefault(const Constant(10))();
  IntColumn get versatility => integer().withDefault(const Constant(10))();
  IntColumn get reaction => integer().withDefault(const Constant(10))();
  IntColumn get reading => integer().withDefault(const Constant(10))();
  IntColumn get intention => integer().withDefault(const Constant(10))();
  IntColumn get control => integer().withDefault(const Constant(10))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 2. Player Model with Computed Skills

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@freezed
class PlayerModel with _$PlayerModel {
  const PlayerModel._(); // Private constructor for computed getters

  const factory PlayerModel({
    required int id,
    required String name,
    // Base attributes
    required int wristSnap,
    required int power,
    required int accuracy,
    required int aggression,
    required int strength,
    required int positioning,
    required int predictability,
    required int creativity,
    required int penetration,
    required int height,
    required int form,
    required int anticipation,
    required int footwork,
    required int platform,
    required int stability,
    required int touch,
    required int vision,
    required int timing,
    required int versatility,
    required int reaction,
    required int reading,
    required int intention,
    required int control,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  // ========== SERVING SKILLS ==========
  double get serveJumpServe =>
      0.40 * wristSnap + 0.40 * power + 0.10 * accuracy + 0.10 * aggression;

  double get serveJumpFloat =>
      0.10 * wristSnap + 0.10 * power + 0.40 * accuracy + 0.40 * aggression;

  // ========== SETTING SKILLS ==========
  double get setOutsideTempo =>
      0.10 * strength + 0.15 * positioning + 0.40 * predictability + 0.25 * creativity;

  double get setMiddle =>
      0.05 * strength + 0.05 * positioning + 0.50 * predictability + 0.50 * creativity;

  double get setBackRow =>
      0.10 * strength + 0.25 * positioning + 0.25 * predictability + 0.40 * creativity;

  double get setOutsideHigh =>
      0.10 * strength + 0.40 * positioning + 0.05 * predictability + 0.05 * creativity;

  // ========== BLOCKING SKILLS ==========
  double get blockOutsideHigh =>
      0.10 * penetration + 0.40 * height + 0.30 * form + 0.20 * anticipation;

  double get blockOutsideTempo =>
      0.20 * penetration + 0.30 * height + 0.40 * form + 0.10 * anticipation;

  double get blockMiddle =>
      0.40 * penetration + 0.10 * height + 0.20 * form + 0.30 * anticipation;

  double get blockRightSide =>
      0.30 * penetration + 0.20 * height + 0.10 * form + 0.40 * anticipation;

  // ========== RECEPTION SKILLS ==========
  double get receptionJumpServe =>
      0.10 * footwork + 0.50 * platform + 0.35 * stability + 0.15 * touch;

  double get receptionJumpFloat =>
      0.35 * footwork + 0.15 * platform + 0.05 * stability + 0.45 * touch;

  // ========== ATTACK SKILLS ==========
  double get attackOutsideTempo =>
      0.40 * vision + 0.15 * timing + 0.15 * power + 0.30 * versatility;

  double get attackMiddle =>
      0.10 * vision + 0.50 * timing + 0.25 * power + 0.15 * versatility;

  double get attackBackRow =>
      0.15 * vision + 0.35 * timing + 0.15 * power + 0.35 * versatility;

  double get attackOutsideHigh =>
      0.30 * vision + 0.05 * timing + 0.50 * power + 0.25 * versatility;

  // ========== DEFENSE SKILLS ==========
  double get defendOutsideTempo =>
      0.40 * reaction + 0.05 * reading + 0.25 * intention + 0.30 * control;

  double get defendMiddle =>
      0.50 * reaction + 0.10 * reading + 0.10 * intention + 0.30 * control;

  double get defendBackRow =>
      0.30 * reaction + 0.20 * reading + 0.20 * intention + 0.30 * control;

  double get defendOutsideHigh =>
      0.20 * reaction + 0.20 * reading + 0.30 * intention + 0.30 * control;
}
```

### 3. Outcome Calculation (in Engine)

```dart
// Example: Serve vs Reception matchup
class OutcomeCalculator {
  static ServeOutcome calculateServeOutcome({
    required PlayerModel server,
    required PlayerModel receiver,
    required ServeType serveType,
  }) {
    final serverSkill = serveType == ServeType.jumpServe
        ? server.serveJumpServe
        : server.serveJumpFloat;

    final receiverSkill = serveType == ServeType.jumpServe
        ? receiver.receptionJumpServe
        : receiver.receptionJumpFloat;

    // Calculate skill differential
    final differential = serverSkill - receiverSkill;

    // Map differential to outcome probabilities
    final (pAce, pError, pGood, pPerfect) = _getServeOutcomeProbabilities(differential);

    final random = Random().nextDouble();
    if (random < pAce) return ServeOutcome.ace;
    if (random < pAce + pError) return ServeOutcome.error;
    if (random < pAce + pError + pGood) return ServeOutcome.good;
    return ServeOutcome.perfect;
  }

  static (double, double, double, double) _getServeOutcomeProbabilities(double differential) {
    // Example mapping:
    // Differential > +5: 30% ace, 5% error, 50% good, 15% perfect
    // Differential 0: 10% ace, 10% error, 50% good, 30% perfect
    // Differential < -5: 5% ace, 15% error, 40% good, 40% perfect

    if (differential > 5) {
      return (0.30, 0.05, 0.50, 0.15);
    } else if (differential > 0) {
      return (0.20, 0.08, 0.50, 0.22);
    } else if (differential > -5) {
      return (0.10, 0.12, 0.45, 0.33);
    } else {
      return (0.05, 0.15, 0.40, 0.40);
    }
  }
}
```

## Benefits

1. **User-friendly**: Scouts/coaches see familiar attributes (Power, Vision, etc.)
2. **Flexible**: Change formulas without touching UI
3. **Realistic**: Different skills matter for different actions
4. **Balanced**: Weighted combinations prevent min-maxing
5. **Extensible**: Easy to add new skills or adjust formulas

## Next Steps

1. Update `Players` table schema in Drift
2. Create `PlayerModel` with computed getters
3. Update outcome strategies to use player-vs-player comparisons
4. Create UI for editing player attributes
5. Add player comparison/scouting reports