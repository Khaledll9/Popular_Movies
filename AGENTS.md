# AGENTS.md — Popular_Movies (mvvm_state_management)

## Commands

```sh
flutter pub get          # install dependencies
flutter analyze          # lint + static analysis
flutter test             # run tests (note: existing test is stale, see below)
flutter run              # launch on connected device/emulator
```

No `flutter format` or codegen steps required.

## Architecture

- **MVVM** with two state-management libs:
  - **Riverpod** (`StateNotifierProvider`) — UI-facing state: `view_models/movie/`, `view_models/favorite/`, `view_models/theme_provider.dart`
  - **GetIt** (service locator) — infra services: `ApiService`, `NavigationService`, `MoviesRepository`. Registered in `service/init_getit.dart`.
- Entrypoint: `lib/main.dart` — calls `setupLocator()`, loads `assets/.env`, then wraps app in `ProviderScope`.
- Navigation uses a global `navigatorKey` from `NavigationService` (not standard `Navigator.of(context)` in many places).
- Theme and favorites persist to `SharedPreferences` via `ThemeProvider` / `FavoritesProvider`.

## API / Secrets

- TMDB v3 API. Works **only** if `assets/.env` contains valid `MOVIES_API_KEY` and `MOVIES_BEARER_TOKEN`.
- Loaded in `main.dart` via `dotenv.load(fileName: "assets/.env")`. Must happen before any API call.
- No `.env.example` exists — the `.env` is checked in with a real token.

## Key quirks

- `dio` is declared in `pubspec.yaml` but **never used**. Actual HTTP calls use `http` package (transitive dependency, not listed directly).
- `analysis_options.yaml` has `file_names: ignore` — nonstandard file names are allowed.
- `test/widget_test.dart` is the default Flutter counter-app smoke test and **does not match** current code. Will fail as-is.
- Riverpod provider files live in subdirectories: `view_models/movie/`, `view_models/favorite/`.
- `flutter_riverpod` uses `flutter_riverpod/legacy.dart` import in `movie_provider.dart` — avoid breaking this if touching that file.

## What to avoid

- Do not remove `dio` from `pubspec.yaml` proactively — the agent who reads this may not know why it's there (it may be planned).
- Do not delete or rewrite `assets/.env` — it's the only source of API credentials.
- Do not break the `file_names: ignore` analyzer rule without team approval.
