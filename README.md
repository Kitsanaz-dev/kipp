# Kipp

Kipp is a personal expense tracker app built with Flutter. It runs entirely on local storage (no backend required) while being designed so a real API can be swapped in later without touching the UI layer.

## Tech stack

| Purpose | Package |
|---|---|
| State management | `flutter_riverpod`, `riverpod_annotation` (code generation) |
| Local storage | `hive_ce`, `hive_ce_flutter` |
| Routing | `go_router` |
| Charts | `fl_chart` |
| Calendar | `table_calendar` |
| Fonts | `google_fonts` (Noto Sans Lao) |
| Bottom nav | `native_glass_navbar` (with `google_nav_bar` fallback) |
| Glass effect | `liquid_glass_renderer` |
| IDs | `uuid` |

## Architecture

Each feature follows Clean Architecture, split into three layers:

```
features/<feature>/
├── domain/
│   ├── entities/        # Plain Dart objects, no framework dependencies
│   └── repositories/     # Abstract interfaces (contracts)
├── data/
│   ├── models/           # Hive models (@HiveType), map to/from entities
│   ├── datasources/      # Talks to Hive directly
│   └── repositories/     # Implements the domain interface using datasources
└── presentation/
    ├── providers/         # Riverpod providers (state)
    ├── screens/           # Full pages
    └── widgets/           # Reusable UI pieces
```

**Why this matters:** the presentation layer only ever depends on the `domain` interface (e.g. `ExpenseRepository`), never on Hive directly. Swapping local storage for a real backend later means writing a new `ExpenseRepositoryImpl` that calls a remote datasource instead — no changes needed in any screen or widget.

### Folder structure

```
lib/
├── core/
│   ├── constant/        # palette, radius, spacing, typo (raw design tokens)
│   ├── res/              # app_colors, app_typo, app_deco (theme-aware wrappers)
│   ├── router/           # go_router config, route paths, page transitions
│   ├── theme/             # AppTheme interface, Light/DarkTheme, ThemeService
│   └── utils/             # currency formatter, date grouping, etc.
├── features/
│   ├── auth/              # Login, register, session (local-first)
│   └── expense/           # Home, expense list, history, profile, add transaction
└── main.dart
```

## State management

Riverpod is used with the **single source of truth + derived providers** pattern:

- `expenseListProvider` (`AsyncNotifier`) is the only provider that reads from Hive. It exposes `add()` / `delete()` methods that write to storage, then invalidate themselves so every dependent provider recomputes automatically.
- `expensesByDayTypeProvider`, `expenseSummaryProvider`, `dailyChartDataProvider`, and `expenseTotalsProvider` are pure derived providers — they `watch` the list above and compute filtered views or aggregates. None of them touch Hive directly.
- Ephemeral UI state (selected tab index, selected day-type filter) stays as local `StatefulWidget` state rather than being lifted into Riverpod, since it doesn't need to be shared or persisted.
- `themeServiceProvider` manages `ThemeMode` (light/dark/system) independently of the color/typography system, and persists the choice to a separate Hive box.

## Design system

Colors, typography, and decorations are exposed through `ThemeExtension`s so they respond automatically to `MaterialApp`'s `theme` / `darkTheme` / `themeMode`, instead of being looked up through a custom provider:

```dart
context.colors.primary   // AppColor
context.typo.title       // AppTypo
context.deco.shadow      // AppDeco
```

Light and dark variants live in `LightTheme` and `DarkTheme`, both implementing the `AppTheme` interface, and are merged into `ThemeData.extensions` in `theme_builder.dart`.

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Re-run `build_runner` any time a `@riverpod` provider or `@HiveType` model is added or changed. After changes to `main.dart` or Hive adapters, use a **hot restart** rather than hot reload — Hive adapter registration only runs once, in `main()`.

## Current status

- ✅ Design system (palette, colors, typography, spacing, radius, shadows) with light/dark support
- ✅ Local-first expense tracking (add, list, filter by day/week/month, chart, calendar view) backed by Hive
- ✅ Routing via `go_router` with custom page transitions
- ⏳ Auth is UI-complete (login/register screens) but not yet wired to a Riverpod provider or persisted session — no route guard yet
- ⏳ Receipt scanning (camera → OCR → auto-fill amount) planned via `google_mlkit_text_recognition` + `google_mlkit_entity_extraction`, not yet implemented

## Notes for future backend integration

Because every feature is split into domain/data/presentation layers, connecting a real API later should only require:

1. A new `*RemoteDatasource` per feature that calls the API via `dio`
2. A new `*RepositoryImpl` (or a flag inside the existing one) that uses the remote datasource instead of the local one
3. No changes to providers, screens, or widgets, since they depend only on the domain repository interface