# Kipp

Kipp is a personal expense tracker app built with Flutter. Auth and expenses are backed by a Go + GORM + Postgres (Neon) REST API; only theme/locale settings stay on-device. The Clean Architecture layering means the backend was swapped in without touching the UI layer.

## Tech stack

| Purpose | Package |
|---|---|
| State management | `flutter_riverpod`, `riverpod_annotation` (code generation) |
| Backend API client | `dio` (JWT bearer auth) |
| Token storage | `flutter_secure_storage` (JWT credential) |
| Settings storage | `hive_ce`, `hive_ce_flutter` (theme/locale only), `shared_preferences` (device-local avatar path) |
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
│   ├── datasources/      # Remote datasources — call the Go API via dio
│   └── repositories/     # Implements the domain interface using datasources
└── presentation/
    ├── providers/         # Riverpod providers (state)
    ├── screens/           # Full pages
    └── widgets/           # Reusable UI pieces
```

**Why this matters:** the presentation layer only ever depends on the `domain` interface (e.g. `ExpenseRepository`), never on the transport. Moving auth and expenses from local Hive storage to the Go API only meant writing new `*RemoteDatasource` classes and new `*RepositoryImpl` bodies — no changes in any screen, widget, provider notifier, or the domain interfaces.

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
│   ├── auth/              # Login, register, session (JWT + Go API)
│   └── expense/           # Home, expense list, history, profile, add transaction
└── main.dart
```

## State management

Riverpod is used with the **single source of truth + derived providers** pattern:

- `expenseListProvider` (`AsyncNotifier`) is the only provider that reads the expense list from the API (`GET /api/expenses`). It exposes `add()` / `delete()` methods that call the API, then invalidate themselves so every dependent provider recomputes automatically.
- `expensesByDayTypeProvider`, `expenseSummaryProvider`, `dailyChartDataProvider`, and `expenseTotalsProvider` are pure derived providers — they `watch` the list above and compute filtered views or aggregates. None of them touch the network directly.
- `authProvider` (`AsyncNotifier`) holds the signed-in `UserEntity`. `build()` calls `GET /api/auth/me` when a JWT is present in secure storage, else emits `null`.
- `apiClientProvider` / `tokenStorageProvider` (in `core/network/`) wire the `dio` instance (base URL from `API_BASE_URL`, bearer-token + 401 interceptors) and the secure token store into the repositories.
- Ephemeral UI state (selected tab index, selected day-type filter) stays as local `StatefulWidget` state rather than being lifted into Riverpod, since it doesn't need to be shared or persisted.
- `themeServiceProvider` manages `ThemeMode` (light/dark/system) independently of the color/typography system, and persists the choice to a separate Hive box. `localeServiceProvider` does the same for the app locale. These two are the only remaining Hive users.

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

Configure the public API URL at build time (default: `http://localhost:3000`):

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
flutter build apk --dart-define=API_BASE_URL=https://api.example.com
```

Alternatively, copy `dart_defines.example.json` to the gitignored
`dart_defines.json`, set `API_BASE_URL`, and use:

```bash
flutter run --dart-define-from-file=dart_defines.json
flutter build apk --dart-define-from-file=dart_defines.json
```

The committed VS Code launch configurations use that file. Use `10.0.2.2`
for the Android emulator and `localhost` for the iOS simulator. Use HTTPS
for release builds and physical devices. Defines and bundled assets are public;
server credentials belong only on the backend. Receipt images are sent with
the JWT to `POST /api/receipts/scan`.

Re-run `build_runner` any time a `@riverpod` provider is added or changed.

## Current status

- ✅ Design system (palette, colors, typography, spacing, radius, shadows) with light/dark support
- ✅ Auth (register / login / session / profile name) backed by the Go API with JWT bearer auth; token in `flutter_secure_storage`
- ✅ Expense tracking (add, list, delete, filter by day/week/month, chart, calendar view) backed by the Go API (`/api/expenses`)
- ✅ Offline / unreachable-backend handling — repositories surface a localized "could not connect" message
- ✅ Routing via `go_router` with custom page transitions
- ⏳ Avatar photos are still device-local (`shared_preferences`, keyed by user id) — waiting on a backend image-upload endpoint
- ✅ Receipt scanning through the authenticated backend API

## Backend integration

Auth and expenses talk to a Go + GORM + Postgres (Neon) REST API:

- `POST /api/auth/register`, `POST /api/auth/login` → `{token, user}`; `GET /api/auth/me`; `PATCH /api/users/me`
- `GET/POST /api/expenses`, `PATCH/DELETE /api/expenses/{id}`
- JWT bearer token, attached by a `dio` request interceptor; a 401 response clears the stored token so the app falls back to logged-out

Each feature keeps the domain/data/presentation split, so the transport lives entirely in `data/datasources/*_remote_datasource.dart` and `data/repositories/*_repository_impl.dart` — providers, screens, widgets, and the `AuthRepository` / `ExpenseRepository` interfaces are untouched. Only theme/locale settings remain on-device (Hive).