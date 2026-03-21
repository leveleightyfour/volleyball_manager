# Volleyball Manager — Match Simulation Architecture & Flow

> A single-page technical guide to how rallies are simulated, how players are placed on court, how serve–receive tactics override positions, and how the UI wires into the engine.  
> Copy this file into your repo as: `docs/match_flow.md` (or anywhere you prefer).

---

## TL;DR

- **`SimController`** advances the rally state machine and emits **`EngineEvent`s**.  
- **`OutcomeStrategy`** decides probabilistic outcomes (serve → pass → set → attack).  
- **`PositionBook` + `PositionResolver`** turn JSON layouts into absolute positions.  
- **`TacticsProvider`** holds per-rotation serve–receive specs (2/3/4 passers & combos).  
- **Planners** (`ServeReceivePlanner`, `ServeTargetPlanner`) use tactics + anchors to place passers and pick serve targets.  
- **`MatchGame`** renders the court/players, listens for events, and animates serves.  
- **`MatchPage`** gates rendering until positions are loaded, so the game starts stable.

---

## Rally Lifecycle (High-Level)

1. **preServe** → engine schedules a serve ball-flight event.  
2. **serve** → outcome decided (in-play or fault).  
3. **reception** → pass outcome (perfect/average/single/overpass).  
4. **setting** → set decision (e.g., middle vs pin).  
5. **attack** → attack result (kill / blocked / error / dug).  
6. **If kill/error/blocked** → point awarded, **rotation advances on sideouts**.  
7. **rallyEnd** → engine bumps `rallyId`, returns to **preServe**.

At each step the engine emits **`EngineEvent`s** which the Flame **`MatchGame`** consumes to animate and re-layout.

```mermaid
sequenceDiagram
  participant UI as MatchGame (Flame)
  participant ENG as SimController
  participant STRAT as OutcomeStrategy
  participant POS as PositionBook/Resolver

  UI->>ENG: advance()
  ENG->>UI: EngineEvent.phaseChanged(preServe)
  ENG->>UI: EngineEvent.serveBallFlight(server, 0.9s)
  UI->>POS: resolve serve/receive layouts + tactics
  UI->>UI: animate ball flight
  UI->>ENG: advance()
  ENG->>STRAT: getServeOutcome()
  STRAT-->>ENG: ServeOutcome.inPlay|fault
  alt inPlay
    ENG->>UI: phaseChanged(reception)
    UI->>ENG: advance()
    ENG->>STRAT: getPassOutcome()
    STRAT-->>ENG: PassOutcome.*
    ENG->>UI: phaseChanged(setting)
    UI->>ENG: advance()
    ENG->>STRAT: getSetOutcome()
    STRAT-->>ENG: SetOutcome.*
    ENG->>UI: phaseChanged(attack)
    UI->>ENG: advance()
    ENG->>STRAT: getAttackOutcome()
    STRAT-->>ENG: AttackOutcome.*
    alt kill/error/blocked
      ENG->>UI: scoreChanged + (maybe) rotationAdvanced
      ENG->>UI: rallyEnded
      ENG->>UI: phaseChanged(preServe)
    else dug
      ENG->>UI: phaseChanged(setting)
    end
  else fault
    ENG->>UI: scoreChanged + rotationAdvanced + rallyEnded
    ENG->>UI: phaseChanged(preServe)
  end
```

---

## Core Models

### `MatchState`

```dart
enum TeamSide { home, away }

enum MatchPhase { preServe, serve, reception, setting, attack, rallyEnd }

@freezed
class Score with _$Score {
  const factory Score({@Default(0) int home, @Default(0) int away}) = _Score;
}

@freezed
class MatchState with _$MatchState {
  const factory MatchState({
    required int rallyId,
    required int rotationTick,     // even=home serves, odd=away serves
    required TeamSide serverSide,  // who serves now
    required Score score,
    required MatchPhase phase,
  }) = _MatchState;

  factory MatchState.initial({TeamSide firstServer = TeamSide.home}) =>
      MatchState(
        rallyId: 1,
        rotationTick: firstServer == TeamSide.home ? 0 : 1,
        serverSide: firstServer,
        score: const Score(),
        phase: MatchPhase.preServe,
      );
}
```

### Rotation math

- **Rotation index 1..6 per side** is derived from `rotationTick`:
  - Home rotation index: `((rotationTick ~/ 2) % 6) + 1`
  - Away rotation index: `(((rotationTick + 1) ~/ 2) % 6) + 1`
- **Rotation advances** on **sideouts** or **serve faults** awarding point to the receiver.

---

## Volleyball Rotation & Libero Rules (5-1 System)

### Zone numbering

```
Zone layout (facing the net, home team's perspective):
  4(LF) | 3(MF) | 2(RF)
  5(LB) | 6(MB) | 1(RB) ← server
```

- Zones 2, 3, 4 = **front row**; zones 1, 5, 6 = **back row**
- The player in zone 1 (RB) serves

### Correct 5-1 rotation zone map

Starting position: S=z1, OH1=z2, MB1=z3, OPP=z4, OH2=z5, MB2=z6

| Rotation | Server | z1  | z2  | z3  | z4  | z5  | z6  | L replaces |
|----------|--------|-----|-----|-----|-----|-----|-----|------------|
| R1       | S      | S   | OH1 | MB1 | OPP | OH2 | **L** | MB2 (back) |
| R2       | OH1    | OH1 | MB1 | OPP | OH2 | **L** | S   | MB2 (back) |
| R3       | MB1    | **L** | OPP | OH2 | MB2 | S   | OH1 | MB1 (serve) → L off-bench when serving |
| R4       | OPP    | OPP | OH2 | MB2 | S   | OH1 | **L** | MB1 (back) |
| R5       | OH2    | OH2 | MB2 | S   | OH1 | **L** | OPP | MB1 (back) |
| R6       | MB2    | **L** | S   | OH1 | MB1 | OPP | OH2 | MB2 (serve) → L off-bench when serving |

**Invariants:**
- OH1 and OH2 are always in opposite rows (one front, one back)
- MB1 and MB2 are always in opposite rows (one front, one back)
- L **replaces the back-row MB** in every rotation
- When MB is serving (R3: MB1, R6: MB2): L comes off the bench; the MB serves from z1 and then transitions to their **defense position z5** after the serve

### Serve formation vs Receive formation

- **Serve formation** (when this team serves): server stands at x≈−0.08 (behind own endline); L shown **off-court at bench position** (`servingBenchRoleFor`) during MB serve rotations (R3/R6); all other players at their rotation zone positions.
- **Receive formation** (`ReceiveFormationCalculator`): L is back on court in z1 (or wherever the back-row MB was); passers pulled to x≈0.14 (deep receive position); non-passers at their rotation-appropriate depth.

### Serving bench rule (`servingBenchRoleFor`)

- **R3** (MB1 serves) → bench = `'L'` (Libero off; MB1 on court)
- **R6** (MB2 serves) → bench = `'L'` (Libero off; MB2 on court)
- **All other rotations** → bench = the back-row MB replaced by Libero (same as `benchRoleFor`)

### Non-passer positioning rules

- **Front-row non-passer**: x ≈ 0.90 (as far forward as legally possible — near net)
- **Back-row non-passer**: x ≈ 0.03 (as far back as legally possible — near endline)
- **Passers**: x ≈ 0.14 (pulled back to deep receive position), y spread to their zone's natural lateral position

### Phase-by-phase player movement

1. **preServe** (1.5s delay): all 12 players animate to serve/receive formation
2. **serve**: serving team stays in formation; serving team transitions to defense during ball flight
3. **reception**: passers move toward ball landing zone; non-passers sprint to pre-attack positions (setter → front-right, MBs → attack line centre, OHs → approach angles)
4. **setting**: ball arcs slowly from receive zone to setter; players already in attack positions
5. **attack**: OHs outside the sideline at attack line, MBs at centre of attack line

### Default defense positions (after serve)

Serving team moves to these fixed positions after contact:

| Role | Target Zone | Position |
|------|-------------|----------|
| S | z1 (RB) | Back-right |
| OPP | z2 (RF) | Front-right |
| Front-row MB | z3 (MF) | Middle block |
| Front-row OH | z4 (LF) | Front-left |
| L | z5 (LB) | Back-left |
| Back-row OH / server OH | z6 (MB) | Back-middle |

When MB is serving: MB→z5, L absent (on bench). All other roles same.

---

## Simulation Engine

### `SimController`

- Core rally state machine holding `MatchState`.
- `advance()` looks at current phase, delegates to `OutcomeStrategy`, emits `EngineEvent`s, and updates `MatchState`.
- Handles **rotation on sideouts** and rally transitions.

Example creation with Riverpod:

```dart
final simControllerProvider = Provider<SimController>((ref) {
  final strategy = EngineOutcomeStrategy(ref); // implements OutcomeStrategy
  return SimController(ref.read, strategy: strategy);
});
```

> `SimController` constructor signature:
>
> ```dart
> SimController(
>   T Function<T>(ProviderListenable<T>) read, {
>   MatchState? initial,
>   required OutcomeStrategy strategy,
> })
> ```

### `OutcomeStrategy`

Determines probabilistic outcomes. Interface (abridged):

```dart
abstract class OutcomeStrategy {
  Future<ServeOutcome?>  getServeOutcome(MatchState s);
  Future<PassOutcome?>   getPassOutcome(MatchState s);
  Future<SetOutcome?>    getSetOutcome(MatchState s);
  Future<AttackOutcome?> getAttackOutcome(MatchState s);
}
```

The default concrete `EngineOutcomeStrategy` uses `ref` to read tactics & random seeds.

### Set option gating

- **Backrow attack** (`setBackRow`): only available when **OPP is back row AND setter is front row**.
  - When OPP is back row but setter is also back row → falls back to `setLeftSideHigh/Tempo`.
- **Pipe** (`setPipe`): only available on perfect pass **and setter is front row**.
- **Tip** (`setTip`): only available on perfect pass **and setter is front row**.

### Optional phase systems (future)

- `AttackBlockSystem` — attacker vs blockers model (stuff/kill/live).
- `AttackDefenceSystem` — dig vs ball-to-floor.
These can be **called inside `getAttackOutcome`** to produce richer results without changing the higher-level flow.

---

## Simulation Model Detail

### Serve → Pass model

Serve only resolves to **`fault`** or **`in_play`**. There is no `ace` at the serve phase.

- Fault probability is driven by `serve_vs_reception` outcome curve (DB keys `error/ace/good/perfect` are remapped to `fault/in_play` before picking).
- The **serve differential** (server skill − receiver skill) is stored internally and carried into the pass phase.
- The serve **zone** (`zone1`, `zone5`, `zone6`, `seam16`, `seam56`) is selected by the number of passers and stored for passer selection in the pass phase.
- The **primary receiver** for the differential calculation is selected by zone using `MatchRoster.getPasserForZone`.

#### Ace attribution

Aces emerge from the **pass phase**: when `PassOutcome.shank` is drawn, `AuditLogService.logPassOutcome` retroactively records an **ace** against the server's stats. The server reference (`_lastServer`) is held between phases.

**Shank probability** scales with serve advantage:

```
pShank = (serveDifferential × 0.013).clamp(0.0, 0.18)
```

Pass outcome chain (each threshold is cumulative):

| Outcome      | Probability source                            |
|-------------|----------------------------------------------|
| perfect     | base + skill modifier                         |
| average     | fixed base                                    |
| singleOption | base − skill modifier × 0.5                  |
| overpass    | remainder after above + shank, capped 1–20%  |
| shank (ace) | `serveDifferential × 0.013`, max 18%          |

---

---

## Coordinate Conventions

All position calculators use a **team-relative y** convention:

| y value | meaning (for BOTH teams after mirroring) |
|---------|------------------------------------------|
| `≈ 0.10` | attacker's own **left pin** (OH, position 4) |
| `≈ 0.90` | attacker's own **right pin** (OPP, position 2) |
| `≈ 0.50` | court centre |

`nx = 0.0` = own endline; `nx = 1.0` = net.

### SetLandingCalculator
- y values authored for home team (OH at top `y≈0.06–0.18`, OPP at bottom `y≈0.82–0.94`).
- For away team, `_toScreen` mirrors y: `ey = 1.0 − ny`.
- Backrow contact: `nx = 0.76–0.82` (~2 m from net), `y ≈ 0.74–0.88` (right-side/position-1 area).
- Pipe contact: `nx = 0.76–0.82`, `y ≈ 0.40–0.60` (centre).

### AttackLandingCalculator
- Landing zones authored for away defending (home attacking).
- When home defends (away attacking), `_toScreen` flips y: `ey = 1.0 − ny`.

### Blocker positioning
- `_blockerCenterY(set, defendingSide)` returns the y of the block seam, matching the **attacking team's** pin position on screen. Home defending flips the base value (`1.0 − base`).
- `_blockerYSpreads(count, set, defendingSide)` determines MB/wing offset direction based on which side of the screen the attacker originates from.
- **Front-row non-blockers** are skipped from the floor map and remain at their defense-formation position (seam coverage near the net).

### Defense floor zones
- Zone 1 (right-back): home `y=0.88`, away `y=0.12` — near the sideline for line-defense coverage.
- Zone 5 (left-back): home `y=0.12`, away `y=0.88`.
- Zone 6 (middle-back): both `y=0.50`.

---

### Pass quality → Blocker count

`MatchRoster.getBlockers` uses pass quality to determine how many blockers the defence assembles:

| Pass quality  | Blockers |
|--------------|---------|
| perfect       | 1       |
| average       | 2       |
| singleOption  | 3       |
| other         | 1       |

Blocker roles are selected by set type (priority-ordered):

| Set type                         | Blocker priority order   |
|---------------------------------|--------------------------|
| leftSideHigh / leftSideTempo    | MB1, OH2, OPP            |
| rightSideHigh / rightSideTempo  | MB1, OH1, OH2            |
| middle                          | MB1, MB2, OPP            |
| pipe                            | MB1, MB2, OH2            |
| backrow                         | MB1, OPP, OH2            |
| tip                             | *(none)*                 |

---

### Attack direction model

`AttackDirection` is zone-precise. Available directions are determined by **set type × pass quality** via `_attackDirectionsFor`, then weighted by attacker `vision` and `versatility` via `_directionWeight`.

#### Enum values

```dart
enum AttackDirection {
  // OH (left-side)
  ohLine,           // zone 1 line
  ohCrossShallow,   // zone 5 cross
  ohCrossSharp,     // zone 4 sharp angle

  // OPP / right-side (mirror of OH)
  oppLine,          // zone 5 line
  oppCrossShallow,  // zone 1 cross
  oppCrossSharp,    // zone 2 sharp angle

  // MB / pipe / backrow
  middleZone1,      // to zone 1
  middleZone5,      // to zone 5
  middleZone6,      // deep zone 6 (pipe / backrow)

  atBlock,          // aimed at block
}
```

#### Available directions by pass quality

**Perfect pass (1 blocker):**

| Set type        | Available directions                                        |
|----------------|------------------------------------------------------------|
| middle          | middleZone1, atBlock, middleZone5                          |
| leftSide*       | ohLine, atBlock, ohCrossShallow, ohCrossSharp              |
| rightSide*      | oppLine, atBlock, oppCrossShallow, oppCrossSharp           |
| pipe            | middleZone6, atBlock, middleZone1, middleZone5             |
| backrow         | oppLine, atBlock, oppCrossShallow, oppCrossSharp           |
| tip             | atBlock, ohCrossShallow                                    |

**Average pass (2 blockers):**

| Set type        | Available directions                          |
|----------------|----------------------------------------------|
| middle          | middleZone1, atBlock, middleZone5             |
| leftSide*       | ohLine, atBlock, ohCrossShallow               |
| rightSide*      | oppLine, atBlock, oppCrossShallow             |
| pipe            | middleZone6, atBlock, middleZone1             |
| backrow         | oppLine, atBlock, oppCrossShallow             |
| tip             | atBlock, ohCrossShallow                       |

**Single option (3 blockers):**

| Set type        | Available directions              |
|----------------|----------------------------------|
| middle          | atBlock                           |
| leftSide*       | atBlock, ohCrossShallow           |
| rightSide*      | atBlock, oppCrossShallow          |
| pipe / backrow  | atBlock, middleZone6              |
| tip             | atBlock                           |

#### Floor defenders by blocker count

`getDefenders` now takes `blockerCount` to remove players who are at the net blocking and add MB1 as a middle-court floor defender when only 1 blocker commits.

| Direction        | 1 blocker          | 2 blockers     | 3 blockers |
|-----------------|--------------------|----------------|------------|
| ohLine          | L, OH2, **MB1**    | L, OH2         | L          |
| ohCrossShallow  | L, OH1, **MB1**    | L, OH1         | L, OH1     |
| ohCrossSharp    | OH1                | —              | —          |
| oppLine         | L, OH1, **MB1**    | L              | L          |
| oppCrossShallow | L, OH2, **MB1**    | L, OH2         | L          |
| oppCrossSharp   | OH2                | —              | —          |
| middleZone1     | L, OH2, **MB1**    | L, OH2         | L, OH2     |
| middleZone5     | L, OH1, **MB1**    | L, OH1         | L, OH1     |
| middleZone6     | L, **MB1**         | L              | L          |
| atBlock         | —                  | —              | —          |

*Blocker compositions (from `getBlockers`): leftSide → MB1 / MB1+OH2 / MB1+OH2+OPP; rightSide → MB1 / MB1+OH1 / MB1+OH1+OH2; middle → MB1 / MB1+MB2 / MB1+MB2+OPP*

#### Direction weighting

```dart
// Line / zone shots: boosted by vision
ohLine / oppLine / middleZone1 / middleZone5 → 0.30 + (vision−10)×0.02

// Cross shots: boosted by versatility
ohCrossShallow / oppCrossShallow → 0.35 + (versatility−10)×0.015

// Sharp cross: requires both vision + versatility
ohCrossSharp / oppCrossSharp → 0.15 + (vision−10)×0.02 + (versatility−10)×0.02

// Deep zone (pipe/backrow)
middleZone6 → 0.25 + (versatility−10)×0.015

// At-block: reduced by vision (smart attackers avoid it)
atBlock → 0.25 − (vision−10)×0.015
```

---

## Positions: JSON → PositionBook

### File

- Path: `assets/config/positions.json`
- Loaded via a `PositionRepository` into a `PositionBook` (`Map<String, PositionLayout>`).

### Key format

```
"<team>|<phase>|r<1..6>|<tacticKey>"
```

- `team` = `home` or `away`
- `phase` = `serve` or `receive`
- `tacticKey`:
  - `"default"` for baseline layouts
  - or a **serve–receive tactic**, e.g. `p3_L+OH1+OPP`, `p2_L+OPP`, `p4_default`

### Layout payload

```json
{
  "anchors": { "server_start": { "x": -0.10, "y": 0.75 }, "seam16": {...} },
  "roles":   { "S": { "x": 0.20, "y": 0.65 }, "OH1": {...}, "L": {...} }
}
```

- **Anchors** are named reference points (serve start, seams, zones, quadrants).
- **Roles** map JSON **role tags** (`S`, `OPP`, `MB1`, `MB2`, `OH1`, `OH2`, `L`) to normalized coordinates in **the team’s own half**:
  - `x` ∈ `[-0.20 .. 1.20]` (allows slightly off-court, e.g., server at `-0.10`)
  - `y` ∈ `[0.00 .. 1.00]` (0 = net side of the half; 1 = endline side of the half)

> **Mirroring**: We always author layouts **in the team’s own half** in a consistent orientation (home at the **bottom** half; away at the **top** half). The `PositionResolver` mirrors horizontally for the away half so the same numbers “feel” symmetrical across the net.

### Resolver APIs

```dart
// Absolute role positions for a given layout
Map<String, Offset> resolveRoles({
  required String phase,                // "serve" | "receive"
  required TeamSide side,               // home | away
  required int rotationIndex1to6,       // 1..6
  required Rect courtRect,              // absolute court rect
  String tactic = 'default',            // or p3_L+OH1+OPP etc.
});

// Single anchor to absolute position (or null if missing)
Offset? resolveAnchor({
  required String phase,
  required TeamSide side,
  required int rotationIndex1to6,
  required Rect courtRect,
  required String anchorName,           // e.g., "server_start"
  String tactic = 'default',
});
```

---

## Tactics: Provider & Keys

### `ServeReceiveTacticSpec`

```dart
class ServeReceiveTacticSpec {
  final int numPassers;            // 2 | 3 | 4
  final List<String> passingRoles; // e.g., ["L","OH1","OPP"]
  String get comboKey => passingRoles.join('+'); // "L+OH1+OPP"
}
```

### Tactic key builder

```dart
String tacticLayoutKey(int n, List<String> roles) =>
    'p${n}_${roles.join('+')}'; // e.g., p3_L+OH1+OPP
```

### Provider

- **`tacticsProvider`** keeps per-rotation specs for both teams.  
- The **Serve‑Receive Debug Overlay** edits:
  - team (home/away)
  - rotation (1..6)
  - number of passers (2/3/4)
  - explicit combo (e.g., `L+OH1+OPP`)

> MatchGame **reads** the spec **right before layout**; it doesn’t need to listen reactively unless you want live updates while the overlay is open.

---

## Planners

### `ServeReceivePlanner`

- Inputs:
  - `side`, `rotationIndex1to6`, `courtRect`
  - `spec` (from tactics)
  - `roleTagToPlayerId` (maps `"L" → playerId`)
  - `resolver` (to fetch anchors if needed)
- Output:
  - `receiveSpots: Map<int, Offset>` — absolute positions for **actual passer player IDs** (everyone else uses baseline `roles` from PositionBook).

Usage inside `MatchGame`:

```dart
final specRaw = ref.read(tacticsProvider.notifier).getSpec(side, rot);
final spec = ServeReceiveTacticSpec(
  numPassers: specRaw.numPassers,
  passingRoles: specRaw.passingRoles,
);

final tagToId = _roleTagToPlayerId(roster);
final planner = ServeReceivePlanner();
final plan = planner.plan(
  side: side,
  rotationIndex1to6: rot,
  courtRect: court,
  spec: spec,
  roleTagToPlayerId: tagToId,
);

// When placing, override base role positions if the player is a passer:
final override = plan.receiveSpots[pid];
final finalPos = override ?? basePos;
```

### `ServeTargetPlanner`

- Picks an in‑half **serve target** given number of passers.  
- Prefers anchors if available (`seam16`, `seam56`, `zone5/6/1`, `quad1..quad4`) with slight jitter to avoid stacking.

```dart
final pick = ServeTargetPlanner(positionResolver, rng: _rng).pickTarget(
  toSide: recvSide,
  rotationIndex1to6: rotRecv,
  courtRect: court,
  numPassers: spec.numPassers,
);
_ball?.serve(from: start, to: pick.target, durationSec: durationSec, onComplete: onDone);
```

---

## MatchGame (Flame)

Responsibilities:
- Render court & players.
- Map **role tags → player IDs** per roster (`OH1`, `OH2`, `MB1`, `MB2`, `S`, `OPP`, `L`).
- On **phase/rotation events**, re‑layout using:
  - Baseline `roles` from `PositionBook` (via `resolveRoles`)
  - Overrides from `ServeReceivePlanner` for passer IDs only
- Animate **serve ball flight** using `ServeTargetPlanner` + `server_start` anchor.
- Small watchdog/jitter to guarantee animation completes.
- 3‑second pause after `rallyEnded` before requesting next `advance()`.

> **Orientation**: Home drawn on **bottom** half; Away on **top** half.  
> The resolver mirrors away points horizontally so JSON can be authored consistently.

---

## MatchPage & Loading Gate

We gate the game UI until positions are loaded, to avoid flicker/inconsistency.

```dart
class MatchPage extends ConsumerWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionsAsync = ref.watch(positionBookProvider);
    return positionsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Positions failed: $e'))),
      data: (book) {
        final sim = ref.watch(simControllerProvider);
        final resolver = ref.watch(positionResolverProviderSync);
        return Scaffold(
          body: MatchGameWidget(sim: sim, resolver: resolver), // your wrapper to create MatchGame
        );
      },
    );
  }
}
```

---

## JSON Authoring Notes

- **Serve layouts** should include `"server_start"` anchor.  
- **Receive layouts** for tactics should include:
  - `"zone5"`, `"zone6"`, `"zone1"` (for 3-pass), `"seam16"`, `"seam56"` (for 2-pass), or `"quad1..quad4"` (for 4-pass), **if** you want `ServeTargetPlanner` to aim there; otherwise it falls back to geometric centers.
- Non-passers should also have stable `"roles"` points per tactic, per rotation — this is what you see on court for everyone **not** in `spec.passingRoles`.

Example entry:

```json
"home|receive|r1|p3_L+OH1+OPP": {
  "anchors": {
    "zone5": { "x": 0.10, "y": 0.25 },
    "zone6": { "x": 0.10, "y": 0.50 },
    "zone1": { "x": 0.10, "y": 0.75 }
  },
  "roles": {
    "L":   { "x": 0.18, "y": 0.50 },
    "OH1": { "x": 0.18, "y": 0.30 },
    "OPP": { "x": 0.18, "y": 0.70 },
    "OH2": { "x": 0.35, "y": 0.30 },
    "MB1": { "x": 0.55, "y": 0.50 },
    "MB2": { "x": 0.55, "y": 0.30 },
    "S":   { "x": 0.20, "y": 0.80 }
  }
}
```

---

## Logging Conventions

- `[CTRL]` — simulation control flow (phase changes, rotation, scoring).  
- `[STRAT]` — strategy decisions (serve/pass/set/attack outcomes).  
- `Loaded N position layouts` — PositionBook size on boot.  
- `→ <key>` — every layout key loaded is printed when `PositionRepository` is in verbose mode.  
- `⚠️ positions: no layout for "key" (roles)` — resolver couldn’t find a layout (wrong key/typo or file not loaded).

---

## Troubleshooting

- **No players showing**: Likely resolve roles returned empty map (key not found). Check console for missing `positions` warnings. Ensure pipe `|` separators in keys and correct rotation index (1..6).  
- **Serve starting on wrong side**: Missing/incorrect `server_start` anchor.  
- **Teams look mirrored oddly**: Remember home is bottom; away is top. Normalized coordinates are authored in each **own half**.  
- **Tactics not applied**: Confirm `tacticKey` built with `tacticLayoutKey()` and passed to `resolveRoles(phase:"receive", tactic: key)` when receiving.  
- **Assets not loaded**: Gate `MatchPage` on `positionBookProvider` `.data` before constructing `MatchGame`.

---

## Extension Hooks (Roadmap)

- **Setter positioning**: add `"post_serve"` role targets and a `PostServePlanner` to move setter & middles after contact.  
- **Ball height/scale**: when animating, scale ball by an altitude curve (e.g., parabolic `h(t)` mapped to sprite scale).  
- **CourtSix / rotation-aware mapping**: pass a role → playerId mapping that respects current on-court six and libero swaps.  
- **Skill models**: plug `AttackBlockSystem`/`AttackDefenceSystem` into `OutcomeStrategy.getAttackOutcome()` for richer rallies.  
- **Per-rotation presets**: expose the debug overlay to edit & persist tactics for **all six rotations** in a single panel.

---

## File Index (Where Things Live)

- `lib/features/match/engine/sim/sim_controller.dart` — rally state machine.  
- `lib/features/match/engine/sim/outcome_strategy.dart` — probabilistic outcomes.  
- `lib/features/match/engine/events/events.dart` — event types.  
- `lib/features/match/engine/positions/position_models.dart` — book/layout/points.  
- `lib/features/match/engine/positions/position_resolver.dart` — JSON → absolute mapping.  
- `lib/features/match/engine/presentation/serve_receive_planner.dart` — passer placement.  
- `lib/features/match/engine/presentation/serve_target_planner.dart` — serve target selection.  
- `lib/features/match/state/tactics_state.dart` — serve–receive specs & provider.  
- `lib/features/match/presentation/debug/serve_receive_debug_overlay.dart` — tactics editor.  
- `assets/config/positions.json` — all positional layouts (serve + receive + tactics).

---

## Design Principles

- **Separation of concerns**: engine vs presentation vs configuration.  
- **Data‑driven**: change layouts/tactics without touching code.  
- **Deterministic‑ish**: random seeded via strategy; logs are clear and structured.  
- **Composable**: planners are tiny and pure; easy to test.

---

## Appendix: Helper snippets

### Building tactic keys

```dart
String tacticLayoutKey(int n, List<String> roles) =>
    'p${n}_${roles.join('+')}'; // e.g., p2_L+OPP, p3_L+OH1+OPP, p4_default
```

### Position providers (Riverpod)

```dart
final positionRepositoryProvider = Provider((ref) => PositionRepository());

final positionBookProvider = FutureProvider<PositionBook>((ref) async {
  final repo = ref.read(positionRepositoryProvider);
  return repo.loadFromAssets();
});

final positionResolverProviderSync = Provider<PositionResolver>((ref) {
  final asyncBook = ref.watch(positionBookProvider);
  return asyncBook.when(
    data: (b) => PositionResolver(b),
    loading: () => PositionResolver(PositionBook.empty),
    error: (_, __) => PositionResolver(PositionBook.empty),
  );
});
```

---

**End.**
