# Mini News Intelligence App

A clean, scalable Flutter assignment demonstrating a business-news intelligence experience using **DummyJSON** as a freely accessible mock content API.

## Why DummyJSON?

DummyJSON requires **no account and no API key**, making the project immediately runnable for evaluation. It provides public posts, search, pagination and tags, which are sufficient to demonstrate the required Flutter architecture and API handling.

**Important:** DummyJSON contains mock posts rather than live journalism. The app treats them as news-like content for assignment/demo purposes.

## Features

- Simple authentication with Hive-persisted login state
- News feed with category/tag filtering
- Pagination using `limit` + `skip`
- Pull-to-refresh
- API-backed search with 500ms debounce
- Article detail
- Persistent offline favorites with Hive
- Loading, error, empty and retry states
- Clean Architecture
- Riverpod state management
- Dio HTTP client

## API

No registration or API key is required.

Base URL: `https://dummyjson.com`

Feed: `GET /posts?limit=10&skip=0`

Search: `GET /posts/search?q=business&limit=10&skip=0`

Pagination: `GET /posts?limit=10&skip=10`

## Run

```bash
flutter clean
flutter pub get
flutter run
```

**No `--dart-define` and no API key are needed.**

## Demo Login

```text
Email: demo@newsapp.com
Password: password123
```

## Architecture

```text
lib/
├── core/              # networking, constants, errors, routing
├── data/              # API/local datasources, models, repositories
├── domain/            # entities and repository contracts
├── presentation/      # screens, Riverpod controllers, widgets
└── main.dart
```

Data flow:

```text
Screen → Riverpod Controller → Repository → Data Source → DummyJSON / Hive
```

## Key Decisions

1. Riverpod manages async UI state and dependencies.
2. Repository interfaces isolate domain logic from external services.
3. Hive stores session state and favorites for offline access.
4. DummyJSON responses are converted into domain `Article` entities.
5. Search is debounced to reduce API calls.
6. Pagination uses DummyJSON's `limit` and `skip`.
7. API failures are exposed through user-friendly error states.
8. No secrets or API keys are required.

## Testing

```bash
flutter analyze
flutter test
```

## Suggested Git Commits

```text
chore: initialize flutter project
feat: add clean architecture structure
feat: add dio client and dummyjson datasource
feat: add hive local persistence
feat: implement riverpod authentication
feat: implement paginated news feed
feat: implement debounced article search
feat: implement article details and favorites
feat: add loading error and empty states
docs: update README and architecture decisions
```

## UI color theme update (October 2026)

The project now uses a shared editorial color palette:
- Deep navy `#172554` for the app bar and strong text
- Indigo `#4F46E5` for primary actions and selected category chips
- Teal `#0D9488` as the secondary theme color
- Soft slate `#F1F5F9` for the page background
- Orange `#F97316` reserved for future breaking-news accents

### Files updated
- `lib/core/theme/app_theme.dart` — shared Material 3 theme definition (new file)
- `lib/main.dart` — applies `AppTheme.lightTheme`
- `lib/presentation/home/home_screen.dart` — colorful selected/unselected category chips

### Apply the same changes manually
1. Copy `lib/core/theme/app_theme.dart` into your project at the same path.
2. In `lib/main.dart`, add `import 'core/theme/app_theme.dart';` and set `theme: AppTheme.lightTheme,` inside `MaterialApp`.
3. In `HomeScreen`, use the updated `ChoiceChip` implementation in the file included in this ZIP.
4. Run `flutter pub get` and then `flutter run`.

No new package dependencies are required for the color theme.


## Article images update (October 2026)

- Home feed article cards and the article detail screen now share `ArticleImage`, which provides loading indicators and a placeholder when an image cannot be loaded.
- DummyJSON `/posts` does not provide article image URLs, so `ArticleModel.fromDummyJson` selects illustrative category-related image URLs when no image is present in the API response. These are illustrative images, not photographs from the actual post.
- The image widget uses the existing `cached_network_image` dependency.
- Image loading requires an internet connection and access to the image host.
