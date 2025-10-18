# Architecture Map

**Goals**
- Keep `MatchGame` a thin view/controller.
- Centralize spatial data in PositionBook (JSON).
- Keep planners pure & testable.
- Sim/Engine owns match state & phase transitions.

**Layers**
UI (Flutter Widgets)
  ↕ reads
Match View (`MatchGame`)
  - reacts to EngineEvents
  - lays out players via PositionResolver
  - asks planners for per-phase placements/targets
  ↕ depends on
Planners
  - ServeReceivePlanner: compute passer placements override
  - ServeTargetPlanner: compute serve targets from tactics + anchors
  ↕ uses
State
  - `tacticsProvider` (Riverpod): per-team, per-rotation SR spec
  - `positionResolverProviderSync`: resolves positions.json immediately (empty fallback)
  ↕ reads/writes
Engine
  - `SimController`: phases, rotation, scoring
  - `OutcomeStrategy`: randomized outcomes per phase
  ↕ loads
Data
  - `positions.json` -> PositionBook (anchors + role points)

**Golden Rules**
- `MatchGame` must not compute tactics; it *reads* them.
- Positions used for rendering must come from PositionBook (mirroring rule).
- Planners are deterministic given inputs (inject RNG if needed).
- Engine events are the only driver of time.