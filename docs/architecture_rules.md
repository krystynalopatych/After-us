# After Us — Architecture Rules

Rules for everything that goes into the repo. If code breaks one of these, fix it before merging.

---

## 1. Layers

The project is a Dart pub workspace with three packages plus the app root.

| Package | What lives there | May import |
|---|---|---|
| `domain` | Models, repository interfaces, use cases. **Pure Dart, no Flutter.** | `equatable`, `async` |
| `data` | Repository implementations (in-memory, browser APIs) | `domain`, `web` |
| `presentation` | Pages, BLoCs, design system, routing, assets | `domain`, Flutter, `flutter_bloc`, `go_router`, `get_it`, `equatable` |
| root (`lib/`) | `main.dart` + DI composition root (`lib/di/`) | everything |

- `presentation` **never** imports `data`. `domain` **never** imports Flutter.
- Only `lib/di/` knows all layers.
- Every package has its own `pubspec.yaml` with `resolution: workspace`. Add a dependency to the package that uses it (`cd domain && dart pub add x`), not to the root.

---

## 2. Folder structure

```
domain/lib/<feature>/
  model/<name>.dart                    enums, entities
  repository/<feature>_repository.dart interface
  use_case/<name>_use_case.dart        business actions

data/lib/<feature>/
  repository/<feature>_repository_impl.dart

presentation/lib/
  feature/<name>/
    bloc/<name>_bloc.dart              + <name>_event.dart, <name>_state.dart (part files)
    page/<name>_page.dart
    model/<name>_config.dart           fixed presentation data (e.g. Level1Config pickup spots)
  design/
    design_src.dart                    the only barrel file
    src/theme/...
    src/widget/<widget>/<widget>_container.dart
    src/widget/<widget>/model/...      design-only models (e.g. CharacterState)
  flow/<name>_flow_router/
    <name>_router.dart, <name>_route.dart
  extension/                           BuildContext + title extensions
  di/di_container.dart                 GetIt instance
  generated/                           flutter_gen output, never edit by hand

lib/di/
  injection.dart                       repositories (+ calls registerUseCases)
  use_case_injection.dart              use cases (no data imports, tests reuse it)
```

- No `src/` folders except in `design/`.
- No barrel files except `design/design_src.dart`.
- One feature = one folder. Before adding one, check whether a folder already exists.

---

## 3. Imports

- Always package imports: `import 'package:presentation/feature/hud/page/hud_page.dart';`
- No relative imports (`../`, `./`, `'di/injection.dart'`).
- Import the exact file you need, never a whole package.

---

## 4. Domain

### Models
- `final class` or `enum`.
- Immutable: all fields `final`, constructors `const`.
- Every model with fields extends `Equatable` and overrides `props`.
- Every model with fields has `copyWith`. A nullable field that must be clearable takes a function:
  ```dart
  FeedbackMessage copyWith({
    String? text,
    String? Function()? heroLine,
  }) => FeedbackMessage(
    text: text ?? this.text,
    heroLine: heroLine != null ? heroLine() : this.heroLine,
  );
  ```
- Named constructors for well-known states: `PlayerStats.initial()`, `Pollution.clean()`.
- Behaviour that belongs to the value goes on the enum or model (`GameLocation.isFar`, `Pollution.airQuality`, `GameLevel.locations`).
- No UI data in domain: no pixels, sizes, colours or images.

### Repository interfaces
- `abstract interface class <Feature>Repository`.
- Standard shape:
  ```dart
  T get value;                 // current value
  Stream<T> get valueStream;   // changes
  void mutate(...);            // one method per action
  void restore(T value);       // from a save
  void reset();                // new game / new level
  ```
- Return `bool` from a mutation that can fail (`InventoryRepository.add` → `false` when full).

### Use cases
- **Any action that touches 2+ repositories, or contains a game rule (numbers, conditions), is a use case.** Never put it in a BLoC.
- Shape: `final class`, repositories as private named formals, a single `call`:
  ```dart
  final class TravelUseCase {
    static const _farTripThirst = 10;

    final LocationRepository _locationRepository;
    final PlayerRepository _playerRepository;

    const TravelUseCase({
      required this._locationRepository,
      required this._playerRepository,
    });

    void call(GameLocation destination) { ... }
  }
  ```
- A use case that combines streams exposes a getter + stream (`LocationPickupsUseCase.pickups` / `.pickupsStream`, merged with `StreamGroup` from `async`).
- Game constants live as `static const _name` in the use case or model that owns the rule.
- Registered in `lib/di/use_case_injection.dart` with `registerFactory`.

### Level start and saves
- `StartLevelUseCase` is the **only** place that resets or restores repositories when a level starts.
- `SaveGameUseCase` is the **only** place that builds a `GameSave`.
- A new piece of state that must survive save/load is three edits: a field on `GameSave`, one line in `StartLevelUseCase` (restore + reset), one line in `SaveGameUseCase`.

---

## 5. Data

- `final class <Feature>RepositoryImpl implements <Feature>Repository`.
- In-memory state is private; getters return unmodifiable copies (`List.unmodifiable`, `Set.unmodifiable`).
- Changes go out through a `StreamController.broadcast()`. Push the new value after every mutation.
- A private `_update(value)` helper when several methods set the same field.
- Update models with `copyWith`, never by rebuilding them field by field.
- Static level content (e.g. pickup layouts) is a `static const` list of records in the impl.
- Platform APIs (`package:web`) live only in data (`AppRepositoryImpl`).

---

## 6. Presentation

### BLoC
- `flutter_bloc`. New BLoCs start empty unless there's a reason.
- Three files: `<name>_bloc.dart` (library, owns imports) with `part '<name>_event.dart';` and `part '<name>_state.dart';`.
- Dependencies come from DI in the initializer list:
  ```dart
  HudBloc()
    : _playerRepository = diContainer.get(),
      _travelUseCase = diContainer.get(),
      super(...)
  ```
- A BLoC may hold **use cases** (for actions) and **repositories only to display one stream**. If it needs two repositories for one action, write a use case.
- Handlers: a short lambda in `on<>()` when it's one line, otherwise a private `_onX(Event, Emitter)` method.
- Listen to streams with `emit.forEach(stream, onData: ...)`; several streams → `Future.wait([...])`.
- Emit with `state.copyWith(...)`, never by rebuilding the state by hand.
- Mapping a domain enum to a design enum is a `static` switch in the BLoC (`_toState`).

### Events
- `sealed class <Name>Event extends Equatable` with `const` constructor and `props => []`.
- One `final class` per event, named `<Name><What happened>`: `Started`, `Tapped`, `Selected`, `Closed`, `Dismissed`, `Toggled`.
- Events with data override `props`.
- Every page BLoC has a `<Name>Started` event that the page adds on creation.

### State
- `final class <Name>State extends Equatable`, `const` constructor, defaults for optional fields, `copyWith`, `props`.
- Step-like UI state is an enum in the state file (`PickupStep`).

### Pages
- `StatefulWidget` with a private constructor and a static `withBloc(...)` factory that creates the BLoC and adds `Started`:
  ```dart
  static Widget withBloc() => BlocProvider(
    create: (_) => HudBloc()..add(const HudStarted()),
    child: const HudPage._(),
  );
  ```
- In `State`: `late final XBloc _bloc;` set in `initState` with `context.read()`, then `BlocBuilder<XBloc, XState>(bloc: _bloc, ...)`.
- A BlocProvider that only sets something on start (e.g. mood) needs `lazy: false`.
- Layout numbers are `static const _name` at the top of the `State` class. No magic numbers inline.
- Asset/title lookups are `static` exhaustive switches at the bottom of the page.

### Config
- Fixed presentation data that is not a single layout number (positions per level, long lists of values) goes into a config class, not into the page.
- File: `feature/<name>/model/<name>_config.dart`, an `abstract final class <Name>Config` with `static const` fields:
  ```dart
  abstract final class Level1Config {
    static const pickupSpots = <Offset>[
      Offset(
        700,
        560,
      ),
    ];
  }
  ```
- Pickup screen positions live in `Level1Config.pickupSpots`, indexed by pickup id (= order of the data layout in `PickupRepositoryImpl`). Moving or reordering a pickup means changing both lists in the same order.

### Scenes
- Every screen is a `Stack`: pictures at the bottom (background, then character), UI on top (tap areas, buttons, dialogs).
- Design size is 1920×1080. `AppPage` wraps everything in `SceneContainer` (16:9, black bars).
- Location screens are `BackgroundContainer(image, elements: [BackgroundElement(left, top, width, height, child)])`.
- Each feature that draws on the game screen is its own `Positioned` layer in `GamePage`.

### Design system
- Reusable widgets live in `design/src/widget/<name>/` and are named `<Name>Container`.
- Exported only through `design_src.dart`.
- Colours and typography come from the theme: `context.colors`, `context.typography`. Images come from `context.images.<name>`.
- Design widgets know nothing about domain or BLoCs: they take plain values and callbacks.

### Routing
- `go_router`. Each flow has `flow/<name>_flow_router/<name>_router.dart` + `<name>_route.dart` (an enum of routes with a `path`).
- Navigate with `AppRoute.x.go(context)` (uses `Router.neglect`): **no back navigation** in the game.
- Opening a deep URL directly redirects to the start screen.

### Assets
- Images in `resources/assets/images/` (flat, `img_*.webp`). Fonts in `resources/fonts/`.
- Images are WebP (quality 85), never PNG. Full-scene pictures (location backgrounds, map, sky, book, station windows) keep their size; wide UI panels are at most 1280 px on the long side; everything else (icons, items, buttons, characters) at most 768 px. The game is served over the web, so every extra MB is load time.
- After adding an image run `dart run build_runner build` from the root; output goes to `presentation/lib/generated/assets/`.
- Never hard-code asset paths; use the generated getters.
- `LoadingPage` precaches every image before the router is shown, and `main.dart` raises the image cache to 512 MB so nothing gets evicted. Don't add separate `precacheImage` calls in pages.
- Switching location keeps the map open: `GameLocationSelected` moves the player under the map (`isTraveling`), and `GamePage` sends `GameMapClosed` once the new scene's images are loaded.

---

## 7. Dependency injection

- `get_it`, single instance `diContainer` in `presentation/lib/di/di_container.dart`.
- Repositories: `registerSingleton` in `lib/di/injection.dart`.
- Use cases: `registerFactory` in `lib/di/use_case_injection.dart`, getting their repositories with `diContainer.get()`.
- Registration lists are sorted alphabetically.

---

## 8. Clean code

- **No comments.** No `//`, `///` or `#` in code or YAML. Names explain the code. Generated files are exempt.
- **Trailing commas.** Every declaration with 2+ parameters and every call with 2+ arguments gets a trailing comma, so each parameter/argument sits on its own line. This covers methods, functions, constructors, constructor calls (`Offset(...)`, `Size(...)`), `copyWith`, widgets and `max(...)`. Closure parameters (`(event, emit) =>`, `(context, state) =>`) stay inline.
  ```dart
  void call(
    Pickup pickup,
    GameLocation target,
  ) { ... }

  _throwPickupUseCase(
    pickup,
    event.target,
  );
  ```
- **Formatting.** `analysis_options.yaml` sets `page_width: 120` and `trailing_commas: preserve`. Run `dart format .` before committing; it keeps the trailing commas and splits the lists.
- `final class` by default. Everything is `final` / `const` where possible.
- Private by default (`_name`). Only expose what other files use.
- Exhaustive `switch` expressions over enums. No `default` that hides a new enum value.
- Dot shorthands for enum values and named constructors where the type is known: `.house`, `const .initial()`.
- Pattern matching for nullable checks: `if (pickup.kind.material case final material?)`.
- Early `return` instead of nested `if`.
- One responsibility per class, short methods.
- Names: `<Feature>Repository`, `<Feature>RepositoryImpl`, `<Action>UseCase`, `<Name>Bloc/Event/State`, `<Name>Page`, `<Name>Container`. Booleans read as questions: `isMapOpen`, `isFar`, `hasSun`.
- No debug code, `print`, or leftover test buttons in merged code.
- `flutter analyze` must report no issues (`flutter_lints`), and `dart format --set-exit-if-changed .` must report 0 changed files.

---

## 9. Tests

- Widget tests in `test/` use the real in-memory repositories (or fakes like `_FakeAppRepository`), registered in `pumpApp`, then `registerUseCases()`.
- Tests must not import `lib/di/injection.dart` (it pulls in `package:web`).
- Use cases are pure Dart: unit-test them with the in-memory repositories from `data`.
- `flutter test` must pass before merging.

---

## 10. Git

- `main` always builds and runs.
- Small branches, merge fast, pull before you start.
- Commit messages are **one line**, no body, no trailers.
- No AI tool attribution in commits or PRs (no tags, no co-author trailers) and no AI tool config files (CLAUDE.md, .claude/).
