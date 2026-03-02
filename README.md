# Coinalyze App

Flutter application that integrates with the [Coinalyze API](https://coinalyze.net) to provide cryptocurrency derivatives market data (open interest, funding rates, liquidations, OHLCV, long/short ratios).

## Architecture

The project follows **Clean Architecture** principles with three layers:

```
lib/
├── core/                          # Shared utilities
│   ├── config/
│   │   └── env_config.dart        # Environment variable access
│   ├── constants/
│   │   └── api_constants.dart     # API base URL, endpoints, enums
│   └── error/
│       └── exceptions.dart        # Custom exception hierarchy
├── data/                          # Data layer
│   ├── datasources/
│   │   └── coinalyze_remote_datasource.dart  # HTTP client (abstract + impl)
│   ├── models/                    # @JsonSerializable model classes
│   │   ├── models.dart            # Barrel export
│   │   ├── api_error_model.dart
│   │   ├── exchange_info_model.dart
│   │   ├── future_market_info_model.dart
│   │   ├── spot_market_info_model.dart
│   │   ├── open_interest_model.dart
│   │   ├── funding_rate_model.dart
│   │   ├── predicted_funding_rate_model.dart
│   │   ├── candlestick_model.dart
│   │   ├── open_interest_history_model.dart
│   │   ├── funding_rate_history_model.dart
│   │   ├── predicted_funding_rate_history_model.dart
│   │   ├── liquidation_model.dart
│   │   ├── long_short_ratio_model.dart
│   │   └── ohlcv_model.dart
│   └── repositories/
│       └── coinalyze_repository_impl.dart  # Concrete repository
├── domain/                        # Domain layer
│   └── repositories/
│       └── coinalyze_repository.dart       # Abstract repository contract
└── main.dart
```

### Layer responsibilities

| Layer | Responsibility |
|-------|----------------|
| **core** | Shared constants, configuration, custom exceptions |
| **domain** | Abstract repository contracts — no dependencies on external packages |
| **data** | Models, remote data sources (HTTP), repository implementations |
| **presentation** | *(future)* UI widgets, state management |

## API Endpoints

All endpoints target `https://api.coinalyze.net/v1`. Authentication is via the `api_key` query parameter.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/exchanges` | Supported exchanges |
| GET | `/future-markets` | Supported future markets |
| GET | `/spot-markets` | Supported spot markets |
| GET | `/open-interest` | Current open interest |
| GET | `/funding-rate` | Current funding rate |
| GET | `/predicted-funding-rate` | Current predicted funding rate |
| GET | `/open-interest-history` | Open interest history |
| GET | `/funding-rate-history` | Funding rate history |
| GET | `/predicted-funding-rate-history` | Predicted funding rate history |
| GET | `/liquidation-history` | Liquidation history |
| GET | `/long-short-ratio-history` | Long/short ratio history |
| GET | `/ohlcv-history` | OHLCV history |

## Setup

### Prerequisites

- Flutter SDK `^3.10.1`
- Dart SDK `^3.10.1`

### 1. Clone & install dependencies

```bash
git clone https://github.com/LucaPalenga/coinalyze_app.git
cd coinalyze_app
flutter pub get
```

### 2. Configure the API key

Copy the example environment file and insert your Coinalyze API key:

```bash
cp .env.example .env
```

Edit `.env`:

```
COINALYZE_API_KEY=your_api_key_here
```

> **Important:** `.env` is in `.gitignore` — your API key will never be committed.

### 3. Generate serialization code

Models use `@JsonSerializable` from `json_serializable`. After any model change, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run

```bash
flutter run
```

## Models & Serialization

All models live in `lib/data/models/` and use:

```dart
@JsonSerializable()
class ExampleModel {
  final String? field;
  const ExampleModel({this.field});

  factory ExampleModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExampleModelToJson(this);
}
```

Generated `.g.dart` files are excluded from version control (`.gitignore`).

## Error Handling

Custom exception hierarchy in `lib/core/error/exceptions.dart`:

- **`ServerException`** — generic server error
- **`BadRequestException`** (400) — invalid parameters
- **`UnauthorizedException`** (401) — invalid/missing API key
- **`RateLimitException`** (429) — rate limit exceeded

## Dependencies

| Package | Purpose |
|---------|---------|
| `http` | HTTP client |
| `flutter_dotenv` | `.env` file loading |
| `json_annotation` | Serialization annotations |
| `json_serializable` | Code generation (dev) |
| `build_runner` | Code generation runner (dev) |
