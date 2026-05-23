# 🎬 Popular Movies — Flutter MVVM Architecture with Riverpod

> **Discover, browse, and curate top-rated cinema — engineered with clean separation of concerns and reactive state management.**

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-8A2BE2)](https://riverpod.dev)
[![GetIt](https://img.shields.io/badge/DI-GetIt-FF6F00)](https://pub.dev/packages/get_it)
[![TMDB](https://img.shields.io/badge/API-TMDB%20v3-01D277)](https://developers.themoviedb.org/3)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 1. 📌 The Problem & The Solution

### Problem
Discovering popular films across streaming platforms lacks a unified, performant, and customizable experience. Existing solutions suffer from monolithic state management, tight coupling between UI and business logic, and poor offline-readiness for user preferences.

### Solution
**Popular Movies** is a Flutter application that consumes **The Movie Database (TMDB) v3 API** to provide a curated, paginated feed of popular films. It is architecturally grounded in **MVVM** with dual state-management layers:

- **Riverpod** (`StateNotifierProvider`) for reactive, testable UI state
- **GetIt** (service locator) for decoupled dependency injection of infrastructure services

The result is a modular, maintainable codebase where data layer, business logic, and presentation are independently swappable and testable.

---

## 2. 🏗 Architectural Patterns & Software Engineering Principles

### MVVM + Clean Separation of Concerns

```
┌─────────────────────────────────────────────────────┐
│  View Layer        (lib/views/)                      │
│  ─────────                                            │
│  ConsumerWidgets — observe ViewModels via Riverpod    │
├─────────────────────────────────────────────────────┤
│  ViewModel Layer   (lib/view_models/)                 │
│  ─────────                                            │
│  StateNotifier — pure business logic, no BuildContext │
├─────────────────────────────────────────────────────┤
│  Service Layer     (lib/service/)                     │
│  ─────────                                            │
│  ApiService, NavigationService — registered in GetIt  │
├─────────────────────────────────────────────────────┤
│  Repository Layer  (lib/repository/)                  │
│  ─────────                                            │
│  MoviesRepository — data source abstraction           │
├─────────────────────────────────────────────────────┤
│  Data / Model Layer (lib/models/)                     │
│  ─────────                                            │
│  Immutable data classes with fromJson/toJson          │
└─────────────────────────────────────────────────────┘
```

### Engineering Principles Applied

| Principle | Implementation |
|---|---|
| **Single Responsibility** | Every class owns exactly one concern — `ApiService` handles HTTP; `NavigationService` handles routing; `MoviesProvider` manages movie list state |
| **Dependency Inversion** | ViewModels depend on repository abstractions injected via `GetIt` — no concrete coupling to HTTP or persistence |
| **Reactive Programming** | UI subscribes to `StateNotifierProvider` streams; mutations propagate automatically via Riverpod's dependency graph |
| **Separation of Concerns** | Views are "dumb" `ConsumerWidget`s; all logic lives in `StateNotifier` classes |
| **Persistence Abstraction** | `SharedPreferences` is wrapped in provider classes (`ThemeProvider`, `FavoritesProvider`) — no raw platform calls in views |

### Why Riverpod + GetIt over alternatives

- **Riverpod** was chosen over raw `ChangeNotifier`/`Provider` for its compile-time safety, auto-disposal, and family providers for parameterized state (e.g., `currentMovie` by index).
- **GetIt** handles service registration because these services are singleton infrastructural concerns — they do not need Riverpod's reactive graph. This hybrid avoids forcing every dependency through a single paradigm.

---

## 3. ⚙️ Key Engineering Features & Technical Depth

### Reactive State Management with Riverpod

The entire UI is driven by `StateNotifierProvider`. When the user scrolls to the bottom, a `ScrollNotification` listener triggers `MoviesProvider.getMovies()`, which:

1. Checks `isLoading` guard (prevents duplicate requests)
2. Fetches genres on first load (cached in state)
3. Fetches next page from TMDB
4. Appends to `moviesList` immutably via `copyWith`
5. Increments `currentPage` for the next request

The `ConsumerWidget` automatically rebuilds only the affected subtree — no manual `setState()` or `notifyListeners()` in widgets.

### Infinite Scroll Pagination

```
ListView.builder ← listens to ScrollNotification
    ↓
pixel == maxScrollExtent && !isLoading
    ↓
ref.read(moviesProvider.notifier).getMovies()
    ↓
ApiService.fetchMovies(page: state.currentPage)
    ↓
state.copyWith(moviesList: [...state.moviesList, ...movies])
```

### Theme Persistence & Dark Mode

`ThemeProvider` (a `StateNotifier`) reads/writes the user's preference to `SharedPreferences`. The `MaterialApp` in `main.dart` watches `themeProvider` and swaps `ThemeData` accordingly. No navigation rebuild — swap is instant.

### Favorites — Local-First Persistence

`FavoritesProvider` persists the user's favorited movies in `SharedPreferences` as a JSON-encoded list. This ensures:
- Favorites survive app restarts without requiring network connectivity
- The favorites list is loaded in the `SplashScreen` before the main view renders
- `clearAllFavs()` is a single atomic operation

### Hero Animations

The movie backdrop image uses Flutter's `Hero` widget with a shared `tag: movieModel.id`, enabling a seamless fly-in transition from the list item to the detail view.

---

## 4. 🧰 Technology Stack & Dependencies

| Category | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter 3.24+ (SDK) | Cross-platform UI framework |
| **Language** | Dart 3.9+ | Type-safe, compiled language |
| **State Management** | `flutter_riverpod ^3.0.3` | Reactive, compile-safe state |
| **DI / Service Locator** | `get_it ^8.2.0` | Singleton service registration |
| **HTTP Client** | `http` (transitive via Flutter SDK) | TMDB API calls |
| **Image Caching** | `cached_network_image ^3.4.1` | Network image caching & rendering |
| **Environment** | `flutter_dotenv ^6.0.0` | API key/secret management |
| **Persistence** | `shared_preferences ^2.5.3` | Local key-value storage |
| **Linting** | `flutter_lints ^6.0.0` | Dart static analysis |
| **Testing** | `flutter_test` (SDK) | Widget & unit testing |
| **API** | TMDB v3 | Movie & genre data |

---

## 5. 📁 Folder Structure

```
lib/
├── constants/                  # App-wide constants
│   ├── api_constants.dart      # TMDB URLs, auth headers from .env
│   ├── my_app_constants.dart   # Image URLs, hardcoded genre names
│   ├── my_app_icons.dart       # Centralized IconData references
│   └── my_theme_data.dart      # Light & dark ThemeData definitions
│
├── enums/
│   └── theme_enum.dart         # ThemeEnum { light, dark }
│
├── models/                     # Immutable data models
│   ├── genre_model.dart        # GenreModel (id, name)
│   └── movies_model.dart       # MovieModel (full TMDB fields)
│
├── repository/
│   └── movies_repo.dart        # MoviesRepository — data source orchestrator
│
├── service/                    # Infrastructure services (GetIt-registered)
│   ├── api_service.dart        # HTTP client for TMDB endpoints
│   ├── init_getit.dart         # GetIt registration setup
│   └── navigation_service.dart # Global navigator key, routing helpers
│
├── utils/
│   └── genre_utils.dart        # Genre ID → name mapping utility
│
├── view_models/                # StateNotifier providers (Riverpod)
│   ├── theme_provider.dart     # Theme toggle, SharedPreferences-backed
│   ├── movie/
│   │   ├── movie_state.dart    # MovieState (page, list, error, loading)
│   │   └── movie_provider.dart # MoviesProvider — fetch, paginate, genre cache
│   └── favorite/
│       ├── favorites_state.dart # FavoritesState (list of MovieModel)
│       └── favorites_provider.dart # FavoritesProvider — add, remove, persist
│
├── views/                      # Screens (ConsumerWidgets)
│   ├── splash_view.dart        # App init: load favorites, fetch movies
│   ├── movies_view.dart        # Paginated popular movies feed
│   ├── movie_details_view.dart # Full movie detail with Hero animation
│   └── favorites_view.dart     # Saved movies list
│
├── widgets/                    # Reusable UI components
│   ├── cached_image.dart       # CachedNetworkImage wrapper with fallback
│   ├── my_error_widget.dart    # Error display with retry callback
│   └── movies/
│       ├── movies_widget.dart       # Movie list card
│       ├── genres_list_widget.dart   # Horizontal genre chips
│       └── favorite_btn.dart         # Heart toggle button
│
└── main.dart                   # App entrypoint (GetIt init → .env → ProviderScope)
```

---

## 6. 🚀 Installation & Configuration Guide

### Prerequisites

- **Flutter SDK** 3.24+ ([install guide](https://docs.flutter.dev/get-started/install))
- **Dart** 3.9+ (bundled with Flutter)
- A **TMDB API key** ([register free](https://www.themoviedb.org/settings/api))

### Setup Steps

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/popular_movies.git
cd popular_movies

# 2. Install dependencies
flutter pub get

# 3. Configure environment
#    Open assets/.env and set your TMDB credentials:
: '
MOVIES_API_KEY = 'your_api_key_here';
MOVIES_BEARER_TOKEN = 'your_bearer_token_here';
'

# 4. Run static analysis (verify no lint errors)
flutter analyze

# 5. Launch the app
flutter run
```

> **⚠️ Important**: The application will crash at startup if `assets/.env` is missing or contains invalid credentials. The `.env` file is loaded synchronously at app start in `main.dart` before `runApp()`.

### Running Tests

```bash
flutter test
```

> **Note**: The existing test suite (`test/widget_test.dart`) is a scaffold default and does not yet match the current feature set. Contributions to expand the test harness are welcome.

---

## 7. 🧭 Future Scalability Roadmap

This section outlines architectural enhancements planned for production readiness and horizontal scaling.

### Short-Term (3–6 months)

| Improvement | Engineering Rationale |
|---|---|
| **Unit test suite for ViewModels** | `StateNotifier` classes are pure Dart — easily testable without widget tree. Add `flutter_test` cases for `MoviesProvider`, `FavoritesProvider`, `ThemeProvider` |
| **API error retry with exponential backoff** | Replace bare `timeout()` in `ApiService` with a retry interceptor (e.g., `dio` if reintroduced) |
| **Pagination with `ScrollController`** | Replace `NotificationListener<ScrollNotification>` with a `ScrollController` + listener for finer-grained control and debounce |

### Medium-Term (6–12 months)

| Improvement | Engineering Rationale |
|---|---|
| **Local database (Drift / Isar)** | Replace `SharedPreferences` for favorites with a relational DB — enables complex queries, indexing, and offline-first architecture |
| **Search & filter** | Add `searchMovies` endpoint, debounced query provider, and genre filter chips as Riverpod `family` providers |
| **Flavored environments** | `.env.dev` / `.env.prod` separation with build flavors (`--dart-define`) |
| **Integration tests** | Use `integration_test` package for end-to-end flows: splash → movie list → detail → favorite → theme toggle |

### Long-Term (12+ months)

| Improvement | Engineering Rationale |
|---|---|
| **Repository caching layer** | Introduce `Repository` pattern with an in-memory + disk cache (e.g., `dart_cache` + Hive), so the app works offline for previously loaded data |
| **Modularization (feature-first packages)** | Extract `movies_api`, `favorites_local`, `theme_ui` into separate Dart packages — enables independent testing, CI caching, and potential micro-frontends |
| **State persistence with Riverpod `Notifier` (v3 API)** | Migrate from legacy `StateNotifier` to the new Riverpod `Notifier` pattern for `ref.watch`-based side effects and auto-disposal |
| **CI/CD pipeline** | GitHub Actions: lint → test → build APK/IPA → deploy to Firebase App Distribution / TestFlight |

---

## 📄 License

This project is open-source and available under the MIT License.

---

*Built with Flutter, Dart, Riverpod, and GetIt. Data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/).*
