# Product Explorer App

A simple Flutter app for browsing products from the DummyJSON API.

## Features

- Product list screen
- Product detail screen
- Search products
- Load more pagination
- Pull-to-refresh on the home screen
- Responsive card-style UI

## Tech Stack

- Flutter
- Dart
- Provider for state management
- HTTP for API calls

## Project Structure

- `lib/main.dart` - App entry point
- `lib/screens/` - Screens such as splash, home, and detail
- `lib/providers/` - App state management
- `lib/services/` - API layer
- `lib/models/` - Product model
- `lib/widgets/` - Reusable UI widgets

## Getting Started

1. Install Flutter SDK.
2. Clone the project.
3. Open the project folder.
4. Run:

```bash
flutter pub get
flutter run
```

## Run in a specific device

```bash
flutter devices
flutter run -d <device_id>
```

## Notes

This app uses the DummyJSON product API:

- https://dummyjson.com/products

It is a lightweight demo app for learning Flutter UI, state management, and API integration.
