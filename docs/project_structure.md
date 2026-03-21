# Volleyball Manager — Project Structure & Status

> Master reference document. Updated as the project evolves.
> Last updated: 2026-03-19 (session 2 — P0/P1/P2 implementation)

---

## Table of Contents

1. [Tech Stack](#tech-stack)
2. [Directory Structure](#directory-structure)
3. [System Layers](#system-layers)
4. [Database Schema](#database-schema)
5. [Player Rating System](#player-rating-system)
6. [Match Simulation Engine](#match-simulation-engine)
7. [Rendering Layer](#rendering-layer)
8. [Position System](#position-system)
9. [Tactics System](#tactics-system)
10. [What Is Missing / Gaps](#what-is-missing--gaps)
11. [Backlog by Priority](#backlog-by-priority)
12. [Document Index](#document-index)

---

## Tech Stack

| Concern | Technology |
|---|---|
| UI Framework | Flutter |
| Game Rendering | Flame game engine |
| State Management | Riverpod |
| Local Database | Drift (SQLite) |
| Code Generation | freezed, json_serializable, drift |
| Asset Config | JSON (positions, skills, outcome curves) |

---

## Directory Structure

```
lib/
├── core/
│   └── db/
│       ├── database.dart              # Drift DB definition, schema, seeding
│       ├── database.g.dart            # Generated
│       └── tables/
│           ├── player_tables.dart     # Players, Teams table definitions
│           └── formula_tables.dart    # SkillFormulas, OutcomeCurves table definitions
│
├── features/
│   ├── match/
│   │   ├── engine/
│   │   │   ├── sim/
│   │   │   │   ├── sim_controller.dart        # Rally state machine (6-phase)
│   │   │   │   ├── outcome_strategy.dart      # EngineOutcomeStrategy (wires sim to tactics)
│   │   │   │   └── tactics_registry.dart      # Older static tactics registry (superseded)
│   │   │   ├── phases/
│   │   │   │   ├── serve_receive_system.dart  # Phase system: serve flight + reception
│   │   │   │   ├── attack_block_system.dart   # Phase system: attacker vs blockers
│   │   │   │   └── attack_defence_system.dart # Phase system: attacker vs defenders
│   │   │   ├── positions/
│   │   │   │   ├── position_models.dart       # PositionBook, PositionLayout, PositionPoints
│   │   │   │   └── position_resolver.dart     # JSON → absolute court coordinates
│   │   │   ├── events/
│   │   │   │   └── events.dart                # EngineEvent freezed union type
│   │   │   ├── outcomes/
│   │   │   │   └── outcomes.dart              # ServeOutcome, PassOutcome, SetOutcome,
│   │   │   │                                  #   AttackDirection, AttackOutcome enums
│   │   │   └── presentation/
│   │   │       ├── serve_receive_planner.dart # Pure: passer placement from tactics
│   │   │       └── serve_target_planner.dart  # Pure: serve target from anchors + jitter
│   │   ├── game/
│   │   │   ├── match_game.dart                # FlameGame root (thin controller)
│   │   │   ├── court_world.dart               # Flame World holding court + players
│   │   │   └── services/
│   │   │       ├── camera_controller.dart     # Pinch-zoom, pan, camera modes
│   │   │       ├── event_handler.dart         # Routes EngineEvents → animations
│   │   │       ├── layout_manager.dart        # Resolves positions, applies overrides
│   │   │       └── simulation_coordinator.dart# Step scheduler, prevents concurrent steps
│   │   ├── components/
│   │   │   ├── court_component.dart           # Renders 18:9 court + net + attack lines
│   │   │   ├── ball_component.dart            # Ease-out lerp serve animation
│   │   │   ├── player_component.dart          # Circle sprite + jersey + name pill
│   │   │   ├── move_scheduler.dart            # Applies MoveEffect to players (unused)
│   │   │   └── zone_overlay_component.dart    # Debug overlay ('O' key): rotation + side
│   │   ├── data/
│   │   │   ├── local/
│   │   │   │   ├── match_audit_log_table.dart # Drift table: per-step JSON audit log
│   │   │   │   ├── match_audit_log_dao.dart   # DAO: insertEntry, getByMatch, getByRally, watchByMatch
│   │   │   │   └── matches_table.dart         # Drift table: match metadata (score, teams, completed)
│   │   │   └── services/
│   │   │       └── audit_log_service.dart     # AuditLogService: rich diagnostic log per phase
│   │   ├── state/
│   │   │   ├── match_state.dart               # MatchState, Score, MatchPhase, TeamSide freezed
│   │   │   ├── match_roster.dart              # MatchRoster: per-rotation player lookup helpers
│   │   │   ├── match_roster_provider.dart     # matchRosterProvider + matchRosterCacheProvider
│   │   │   └── tactics_state.dart             # TacticsNotifier, ServeReceiveTacticSpec, provider
│   │   └── presentation/
│   │       ├── match_page.dart                # Gates render until positionBookProvider loaded
│   │       └── debug/
│   │           └── serve_receive_debug_overlay.dart  # Overlay to edit tactics per rotation
│   │
│   └── player/
│       ├── data/
│       │   ├── local/
│       │   │   ├── player_dao.dart            # Drift DAO: CRUD + queries for Players (incl. getByTeamId)
│       │   │   └── player_tables.dart         # Players table (23 attrs + 5 ratings)
│       │   ├── dto/
│       │   │   └── player_dto.dart            # Data transfer objects
│       │   ├── seed/
│       │   │   ├── database_seeder.dart       # Seeds Players/Teams/TeamPlayers from JSON
│       │   │   └── player_seed.json           # 14 players × 2 teams, role-appropriate attributes
│       │   ├── repositories/
│       │   │   └── player_repository.dart     # Coords DAO + calculators (incl. getByTeamId)
│       │   └── providers/
│       │       ├── player_providers.dart      # Riverpod providers for player data
│       │       └── player_providers.g.dart    # Generated
│       └── domain/
│           ├── skill_calculator.dart          # SkillCalculator + OutcomeCurveCalculator
│           ├── position_rating_calculator.dart# Computes 5 position ratings from skills
│           ├── position_rating_service.dart   # Single-player rating update + persist
│           └── position_rating_batch_service.dart # Batch rating updates (recalculateTeamPlayers fixed)

assets/
├── config/
│   ├── positions.json       # Court layouts — serve (rotation-specific per R1-R6) + receive
│   ├── skill_formulas.json  # 19 weighted-sum formulas for derived skills
│   ├── outcome_curves.json  # Probability tables for 4 matchup types vs skill differential
│   ├── position_weights.json# Weights for computing 5 position ratings from skills
│   └── player_seed.json     # 14 seeded players (2 × 7-player rosters)

docs/
├── architecture.md          # Layer diagram + golden rules
├── contracts.md             # positions.json key/value format spec
├── match_flow.md            # Full rally lifecycle + Mermaid sequence diagram
├── match_game_refactoring.md# Notes on splitting MatchGame into services
├── player_rating_system.md  # Attribute list + skill formula tables + implementation
├── position_rating_system.md# How position ratings are derived from skills
├── position_rating_approaches.md # Design options considered
├── POSITION_RATING_SUMMARY.md    # Summary of position rating implementation
├── scaling_to_football_manager.md# Long-term vision notes
└── project_structure.md     # This file — master reference
```

---

## System Layers

```
UI (Flutter Widgets)
  ↕
Match View (MatchGame — Flame)
  - Reacts to EngineEvents
  - Lays out players via PositionResolver + planners
  - Animates serves, player moves
  ↕
Planners (pure, testable)
  - ServeReceivePlanner: passer placement overrides
  - ServeTargetPlanner:  serve target from tactics + anchors
  ↕
State (Riverpod)
  - tacticsProvider:             per-team, per-rotation SR spec
  - positionResolverProviderSync: resolves positions.json immediately
  - simControllerProvider:       rally state machine instance
  ↕
Engine
  - SimController:      phases, rotation, scoring
  - OutcomeStrategy:    probabilistic outcomes per phase
  - Phase Systems:      per-phase skill models (not yet wired in)
  ↕
Data / Config
  - Drift DB:           Players, Teams, SkillFormulas, OutcomeCurves
  - positions.json:     court layout book
  - skill_formulas.json + outcome_curves.json + position_weights.json
```

**Golden Rules**
- `MatchGame` must not compute tactics — it reads them.
- Positions used for rendering must come from `PositionBook` (mirroring rule).
- Planners are deterministic given inputs (inject RNG if needed).
- Engine events are the only driver of time.

---

## Database Schema

Schema version: **3** (non-destructive migration: v2→v3 adds new tables, preserves existing data)

### `Players` (30 columns)

| Group | Columns |
|---|---|
| Identity | id (PK), name, createdAt, updatedAt |
| Serving attrs | wristSnap, power, accuracy, aggression |
| Setting attrs | strength, positioning, predictability, creativity |
| Blocking attrs | penetration, height, form, anticipation |
| Reception attrs | footwork, platform, stability, touch |
| Attack attrs | vision, timing, versatility |
| Defense attrs | reaction, reading, intention, control |
| Position ratings | ratingOh, ratingOpp, ratingMb, ratingS, ratingL |

All 23 attribute ints default to 10. All 5 rating reals are computed and stored.

### `Teams`

| Column | Type |
|---|---|
| id | PK |
| name | text |

### `TeamPlayers`

Join table linking players to teams.

| Column | Type | Notes |
|---|---|---|
| id | PK | |
| teamId | FK → Teams | |
| playerId | FK → Players | |
| roleTag | text | S / OH1 / OH2 / MB1 / MB2 / OPP / L |
| rotationOrder | int | 1–7 |
| isStarter | bool | default true |

### `Matches`

| Column | Type | Notes |
|---|---|---|
| id | PK | |
| homeTeamId | int | |
| awayTeamId | int | |
| startedAt | text | ISO-8601 |
| completedAt | text? | null until match ends |
| homeScore | int | |
| awayScore | int | |
| isComplete | bool | |

### `MatchAuditLog`

Per-step diagnostic log. One row per outcome event per rally.

| Column | Type | Notes |
|---|---|---|
| id | PK | |
| matchId | int | FK → Matches |
| rallyId | int | |
| phase | text | e.g. "serve", "reception" |
| eventType | text | e.g. "serveOutcome", "attackOutcome" |
| payload | text | JSON: result, player skills, differential, probabilities, score, rotations |
| occurredAt | DateTime | auto-set |

### `SkillFormulas`

Seeded from `skill_formulas.json`. Stores 19 named formulas as JSON-encoded weighted maps.

### `OutcomeCurves`

Seeded from `outcome_curves.json`. Stores probability distributions keyed by matchup type and skill differential. Matchups: `serve_vs_reception`, `attack_vs_block`, `attack_vs_defense`, `set_quality`.

---

## Player Rating System

### Attributes → Skills → Position Ratings (pipeline)

```
23 base attributes (1-20 int)
  ↓  skill_formulas.json (19 weighted sums)
19 derived skill values (1-20 float)
  ↓  position_weights.json (5 position weight profiles)
5 position ratings: OH, OPP, MB, S, L (1-20 float, stored on player row)
```

### Derived Skills (19 total)

| Category | Skills |
|---|---|
| Serving | serveJumpServe, serveJumpFloat |
| Setting | setOutsideTempo, setMiddle, setBackRow, setOutsideHigh |
| Blocking | blockOutsideHigh, blockOutsideTempo, blockMiddle, blockRightSide |
| Reception | receptionJumpServe, receptionJumpFloat |
| Attack | attackOutsideTempo, attackMiddle, attackBackRow, attackOutsideHigh |
| Defense | defendOutsideTempo, defendMiddle, defendBackRow, defendOutsideHigh |

### Outcome Curves

Probability lookup: `matchupKey` × `skill differential` → probability map (interpolated).

**Fully wired into `EngineOutcomeStrategy` via `SkillCalculator` + `OutcomeCalculator`.**

---

## Match Simulation Engine

### Rally State Machine (SimController)

```
preServe → serve → reception → setting → attack → rallyEnd → preServe
```

- Rotation advances on sideouts (non-serving team scores).
- **Ace**: server gets point, no rotation (keeps serve).
- **Fault**: receiver gets point + rotation.
- Home rotation index: `((rotationTick ~/ 2) % 6) + 1`
- Away rotation index: `(((rotationTick + 1) ~/ 2) % 6) + 1`

### Engine Events

| Event | Payload |
|---|---|
| `phaseChanged` | phase, rallyId |
| `serveBallFlight` | fromSide, durationSec |
| `playerMove` | playerId, toX, toY, durationSec |
| `scoreChanged` | home, away |
| `rotationAdvanced` | rotationTick, serverSide |
| `rallyEnded` | pointTo, rallyId |

`playerMove` events are triggered on every `phaseChanged` / `rotationAdvanced` via `MatchGame._animateAllPlayersToFormation()`.

### Outcome Strategy (EngineOutcomeStrategy)

| Phase | Implementation |
|---|---|
| Serve outcome | Server role from `MatchRoster.getServer()`. Serve type (jump vs float) from dominant skill. Zone picked by tactic `numPassers`. Outcome from `serve_vs_reception` curve (ace/fault/inPlay). |
| Pass outcome | Primary passer from tactics `passingRoles`. Skill modifier adjusts base probability buckets per `numPassers`. |
| Set outcome | Setter skill weighted by pass quality (perfect → all options; overpass → forced high). Uses `_setOptionsForPassQuality()`. |
| Attack outcome | Attacker vs blockers via `attack_vs_block` curve. If dug: attacker vs defenders via `attack_vs_defense` curve. Attack direction from attacker `vision`+`versatility`. |

All outcomes written to `MatchAuditLog` via `AuditLogService` with: result, player names, skill values, skill keys, differential, probability map, score, rotations.

### Match Roster (MatchRoster)

`MatchRoster` provides per-phase player lookup keyed by role tag:
- `getServer(side, rotationIndex)` — rotation 1–6 → S/MB1/OH1/OPP/OH2/MB2
- `getSetter(side)` → S
- `getAttacker(side, setOutcome)` → MB1/OH1/OPP/S by set type
- `getBlockers(side, setOutcome)` → 0–2 blockers by set type
- `getDefenders(side, attackDirection)` → 1–3 defenders by direction
- `getPassers(side, roleTags)` → passers from tactics

---

## Rendering Layer

`MatchGame` (FlameGame) is composed of four services:

| Service | Responsibility |
|---|---|
| `CameraController` | Pinch-zoom (0.5–3.0x), pan, 3 camera modes |
| `LayoutManager` | Resolves positions from `PositionBook`, applies tactic overrides |
| `EventHandler` | Routes `EngineEvent`s → ball animation / phase transitions / scoring |
| `SimulationCoordinator` | Step scheduler, prevents concurrent `advance()` calls |

Player IDs are hardcoded in `MatchGame` (id 1–7 home, 8–14 away) but match the seeded DB. `LayoutManager.buildFormationMoves()` computes `MoveCommand`s for all 12 on-court players and is called on every phase/rotation change to animate continuous formation movement.

---

## Position System

### Key Format

```
"<team>|<phase>|r<1..6>|<tacticKey>"
```

- `team`: `home` | `away`
- `phase`: `serve` | `receive`
- `tacticKey`: `default` (serve) or `p2_L+OH1`, `p3_L+OH1+OPP`, `p4_default`, etc.

### Layout Schema

```json
{
  "anchors": { "server_start": {"x": -0.10, "y": 0.75}, "zone6": {"x": 0.10, "y": 0.50} },
  "roles":   { "S": {"x": 0.20, "y": 0.65}, "L": {"x": 0.25, "y": 0.40} }
}
```

- Coordinates are in own-half normalized space: `x ∈ [-0.20..1.20]`, `y ∈ [0.00..1.00]`
- `y=0` = net side, `y=1` = endline
- Only home layouts need authoring; `PositionResolver` mirrors horizontally for away

### positions.json Coverage

- **Serve layouts** (`home|serve|rN|default`, `away|serve|rN|default`): All 6 rotations authored. Server role differs per rotation: R1=S, R2=MB1, R3=OH1, R4=OPP, R5=OH2, R6=MB2. Libero shown in back-row substitute position.
- **Receive layouts** (`home|receive|rN|default`, `away|receive|rN|default`): All 6 rotations present. Also: per-tactic 2-passer combos (p2_L+OH1 etc.) authored for `away|receive|r1|*`.
- **Gap**: receive layouts for rotations 2–6 are still identical (rotation-specific differentiation not yet authored).
- **Gap**: No in-rally layouts (reception/setting/attack phases) — players animate to serve/receive formation on all phase changes.

---

## Tactics System

`TacticsNotifier` (Riverpod `StateNotifier`) stores per-team, per-rotation `ServeReceiveTacticSpec`:

```dart
class ServeReceiveTacticSpec {
  final int numPassers;          // 2 | 3 | 4
  final List<String> passingRoles; // e.g., ["L","OH1","OPP"]
  String get comboKey => passingRoles.join('+');
}
```

The `ServeReceiveDebugOverlay` allows live editing of tactics per rotation in-game (toggled with 'O').

---

## What Is Missing / Gaps

### 1. Receive Layouts Not Differentiated by Rotation

`home|receive|rN|default` entries for R2-R6 still have identical role positions. Players look the same in all receive rotations. Differentiated rotation-specific receive positions not yet authored.

### 2. No In-Rally Phase Positions

`positions.json` only has `serve` and `receive` layouts. During rally phases (reception, setting, attack), all players animate to the same serve/receive formation. Phase-specific positions (e.g. setter running to net, hitters approaching) not yet authored.

### 3. build_runner Not Run

All Drift-generated files (`database.g.dart`, `player_dao.g.dart`, `match_audit_log_dao.g.dart`, `events.freezed.dart`) may be stale. Run before first launch:
```
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. MatchGame Roster Still Hardcoded PlayerLite

`MatchGame` still uses hardcoded `PlayerLite` objects with static role/number assignments. The DB-seeded players (ids 1–14) match these ids, but player names and detailed attributes are not loaded into the rendering layer from DB.

### 5. Matches Table Not Wired to AuditLogService in Play

`AuditLogService.startMatch()` must be called before simulation begins to create the match record. This call is not yet wired into any startup flow (e.g. `MatchPage` or `SimulationCoordinator`).

---

## Backlog by Priority

### P0 — COMPLETED ✓
- [x] Seed DB with dummy player data (14 players, 2 teams — `assets/config/player_seed.json`)
- [x] Add `TeamPlayers` join table (team–player relationship)
- [x] Wire `SkillCalculator` + `OutcomeCalculator` into `EngineOutcomeStrategy`
- [x] Implement serve fault + ace probability (`serve_vs_reception` curve)
- [x] Add `MatchAuditLog` table + `AuditLogService` (granular diagnostic log per phase)
- [x] Add `Matches` table + `MatchAuditLogDao`
- [x] Add `ServeOutcome.ace` + update `SimController` (ace = point to server, no rotation)

### P1 — COMPLETED ✓
- [x] Implement direction selection: serve zone target, attack direction from vision/versatility
- [x] Use `PassOutcome` quality to influence `SetOutcome` selection
- [x] Author rotation-specific serve layouts in `positions.json` (R1–R6, correct server per rotation)
- [x] Animate all players on phase changes via `LayoutManager.buildFormationMoves()` + `MoveScheduler`
- [x] Add `MatchRoster` with per-rotation player lookup (server, setter, attacker, blockers, defenders)
- [x] Fix `recalculateTeamPlayers()` in `PositionRatingBatchService` (uses `getByTeamId()`)

### P2 — COMPLETED ✓
- [x] Non-destructive DB migration (v2→v3 creates new tables without dropping existing data)
- [x] `PlayerDao.getByTeamId()` + `PlayerRepository.getByTeamId()` via raw SQL join

### Remaining / Next Steps
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Wire `AuditLogService.startMatch()` into match startup (MatchPage or SimulationCoordinator)
- [ ] Author rotation-specific receive layouts (R2–R6 currently identical)
- [ ] Add in-rally phase positions to `positions.json` (reception, setting, attack approach)
- [ ] Load DB player names into `MatchGame` rendering layer (replace static surnames list)

### P3 — UX and additional features
- [ ] Team management and roster screens
- [ ] Player attribute editor UI
- [ ] Match replay from `MatchAuditLog`
- [ ] Match statistics screen (using audit log)

---

## Document Index

| File | Purpose |
|---|---|
| `docs/architecture.md` | Layer diagram, golden rules |
| `docs/contracts.md` | `positions.json` key/value spec |
| `docs/match_flow.md` | Full rally lifecycle, Mermaid sequence diagram, API reference |
| `docs/match_game_refactoring.md` | Notes on the `MatchGame` service decomposition |
| `docs/player_rating_system.md` | Full attribute list, skill formula tables, `PlayerModel` implementation |
| `docs/position_rating_system.md` | How 5 position ratings are derived from skills |
| `docs/position_rating_approaches.md` | Design options considered for position ratings |
| `docs/POSITION_RATING_SUMMARY.md` | Summary of position rating implementation |
| `docs/scaling_to_football_manager.md` | Long-term vision |
| `docs/project_structure.md` | This file — master reference |
