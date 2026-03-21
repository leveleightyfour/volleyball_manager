# MatchGame Refactoring Summary

## Overview
The MatchGame class has been refactored to extract responsibilities into specialized service classes, reducing it from a monolithic ~980-line class to a coordinated system of focused components.

## New Architecture

### Created Service Classes

#### 1. **CameraController** (`services/camera_controller.dart`)
**Responsibilities:**
- Camera positioning (center, top-left, custom positions)
- Zoom management with constraints
- Pan and pinch gesture handling
- View mode switching (full court, tactical quarter view)

**Key Methods:**
- `centerCourt({double? zoom})`
- `fitCourtToWidth()`
- `pinCourtTopLeft({double? zoom})`
- `setCourtZoom(double z)`
- `positionCourtTopLeftQuarter()`
- `positionCourtTopTwoThirds()`
- `onScaleStart()`, `onScaleUpdate()`, `onScaleEnd()`

**Benefits:**
- Isolates all camera logic in one place
- Easier to test camera behavior
- Cleaner gesture handling

#### 2. **LayoutManager** (`services/layout_manager.dart`)
**Responsibilities:**
- Calculate court dimensions and bounds
- Resolve player positions based on tactics and rotation
- Handle serve/receive formation layouts
- Map role tags to player IDs
- Update visual components with new positions

**Key Methods:**
- `computeCourtRect(Vector2 canvasSize)`
- `getHalfRect(Rect court, TeamSide side)`
- `updateLayout({...})` - Main method to position all players
- `getFallbackServerStart()`
- `pickServeTarget()` - Uses ServeTargetPlanner

**Benefits:**
- Separates positioning logic from rendering
- Easier to modify formation algorithms
- Testable without Flame game engine

#### 3. **EventHandler** (`services/event_handler.dart`)
**Responsibilities:**
- Process events from the simulation engine
- Coordinate player movement animations
- Manage ball animations (serve, etc.)
- Trigger simulation steps at appropriate times
- Manage serve-in-flight state

**Key Methods:**
- `handleEvents(List<EngineEvent> events)`
- `animateServe({...})`
- `resetServeState()`

**Benefits:**
- Centralizes event handling logic
- Cleaner state management for animations
- Easier to add new event types

#### 4. **SimulationCoordinator** (`services/simulation_coordinator.dart`)
**Responsibilities:**
- Manage simulation step lifecycle
- Handle step requests and queuing
- Prevent concurrent stepping
- Provide callbacks for event handling

**Key Methods:**
- `requestStep()` - Queue or execute a simulation step
- Internal `_stepSim()` - Executes the step

**Benefits:**
- Prevents race conditions in stepping
- Clean separation of simulation control
- Easy to modify step scheduling logic

## Integration Pattern

### Before (Monolithic):
```dart
class MatchGame extends FlameGame {
  // 980+ lines mixing:
  // - Camera control
  // - Event handling
  // - Player positioning
  // - Simulation stepping
  // - Gesture handling
  // - Animation coordination
}
```

### After (Delegated):
```dart
class MatchGame extends FlameGame {
  late final CameraController _cameraController;
  late final LayoutManager _layoutManager;
  late final EventHandler _eventHandler;
  late final SimulationCoordinator _simCoordinator;

  @override
  Future<void> onLoad() async {
    // Initialize services
    _cameraController = CameraController(...);
    _layoutManager = LayoutManager(...);
    _eventHandler = EventHandler(...);
    _simCoordinator = SimulationCoordinator(...);

    // Delegate to services
  }

  void centerCourt() => _cameraController.centerCourt();
  void _layoutPlayers() => _layoutManager.updateLayout(...);
  void _handleEngineEvents(events) => _eventHandler.handleEvents(events);
  void _requestStep() => _simCoordinator.requestStep();
}
```

## Benefits of Refactoring

### 1. **Single Responsibility Principle**
Each class now has one clear purpose:
- CameraController → Camera manipulation
- LayoutManager → Player positioning
- EventHandler → Event processing
- SimulationCoordinator → Simulation lifecycle

### 2. **Testability**
- Services can be tested independently
- Mock dependencies easily
- No Flame game engine required for unit tests

### 3. **Maintainability**
- Easier to find and fix bugs
- Clear boundaries between concerns
- Smaller, focused files

### 4. **Extensibility**
- Add new camera modes without touching layout code
- Modify positioning without affecting events
- Easy to add new event types

### 5. **Reduced Complexity**
- From 1 class with 980 lines
- To 5 classes with ~150-300 lines each
- Each class is easier to understand

## Next Steps

To complete the integration:

1. **Initialize services in `onLoad()`:**
   ```dart
   _cameraController = CameraController(
     getCamera: () => cameraComp,
     getCanvasSize: () => size,
     getCourtBounds: () => _courtBounds,
     courtPadding: courtPadding,
   );

   _layoutManager = LayoutManager(
     positionResolver: positionResolver,
     ref: ref,
     playerNodes: _playerNodes,
     overlay: overlay,
     homePlayers: homePlayers,
     awayPlayers: awayPlayers,
     courtPadding: courtPadding,
     rng: _rng,
   );

   _eventHandler = EventHandler(
     moveScheduler: _moveScheduler,
     ball: _ball,
     onLayoutUpdate: () => _layoutFromCanvas(size),
     requestStep: () => _simCoordinator.requestStep(),
   );

   _simCoordinator = SimulationCoordinator(
     sim: sim,
     onEvents: _eventHandler.handleEvents,
     onRotationSync: _syncRotationFromEngine,
   );
   ```

2. **Replace camera methods:**
   - Delegate all `centerCourt()`, `fitCourtToWidth()`, etc. to `_cameraController`
   - Replace gesture handlers with `_cameraController.onScaleStart()`, etc.

3. **Replace layout methods:**
   - Replace `_layoutFromCanvas()` with `_layoutManager.updateLayout()`
   - Remove duplicated role mapping logic

4. **Replace event handling:**
   - Replace `_handleEvents()` with `_eventHandler.handleEvents()`
   - Remove serve-in-flight state from MatchGame

5. **Replace simulation stepping:**
   - Replace `_requestStep()` and `_stepSim()` with `_simCoordinator.requestStep()`

## Migration Status

✅ **Completed:**
- CameraController class created (10KB, ~250 lines)
- LayoutManager class created (9KB, ~280 lines)
- EventHandler class created (4KB, ~140 lines)
- SimulationCoordinator class created (2KB, ~60 lines)
- Services integrated into MatchGame.onLoad()
- All methods delegated to appropriate services
- Unused code removed
- Imports cleaned up

**Final Results:**
- **Before:** 948 lines (monolithic)
- **After:** 462 lines (orchestration only)
- **Reduction:** 486 lines removed (51% decrease)
- **Code distribution:**
  - MatchGame: 462 lines (orchestration & lifecycle)
  - CameraController: ~250 lines (camera & gestures)
  - LayoutManager: ~280 lines (positioning & formations)
  - EventHandler: ~140 lines (event processing)
  - SimulationCoordinator: ~60 lines (step management)

⏳ **Pending:**
- Full integration testing
- Verify all functionality works as before
- Performance validation

## File Locations

```
lib/features/match/game/
├── match_game.dart          # Main game class (to be simplified)
├── services/
│   ├── camera_controller.dart      # ✅ Camera & gestures
│   ├── layout_manager.dart          # ✅ Player positioning
│   ├── event_handler.dart           # ✅ Event processing
│   ├── simulation_coordinator.dart  # ✅ Simulation stepping
│   └── move_scheduler.dart          # Existing (unchanged)
├── components/
│   ├── court_component.dart
│   ├── player_component.dart
│   ├── ball_component.dart
│   └── zone_overlay_component.dart
└── model/
    └── move_command.dart
```

## Testing Strategy

Each service can now be unit tested:

```dart
test('CameraController centers court correctly', () {
  final controller = CameraController(...);
  controller.centerCourt(zoom: 2.0);
  expect(camera.viewfinder.zoom, 2.0);
  expect(camera.viewfinder.position, isCenter);
});

test('LayoutManager positions players in correct formation', () {
  final manager = LayoutManager(...);
  manager.updateLayout(
    canvasSize: Vector2(800, 600),
    serverSide: TeamSide.home,
    ...
  );
  expect(playerNodes[1].position, isOnCourt);
});

test('EventHandler processes serve event correctly', () {
  final handler = EventHandler(...);
  handler.handleEvents([ServeBallFlight(...)]);
  expect(handler.serveInFlight, isTrue);
});

test('SimulationCoordinator prevents concurrent stepping', () async {
  final coordinator = SimulationCoordinator(...);
  coordinator.requestStep();
  coordinator.requestStep(); // Should queue
  await Future.delayed(Duration(milliseconds: 10));
  verify(sim.advance()).called(2); // Called sequentially
});
```
