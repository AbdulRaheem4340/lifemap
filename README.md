# LifeMap

> Your life, mapped and understood.

LifeMap is a cross-platform Flutter app that records your journeys in the background and turns them into a personal map of your movement. Track trips in real time, review session history and charts, and get AI-generated weekly insights about your activity.

## Features

- **Live activity tracking** — real-time location tracking with flutter_map, a pulsing location marker, live stats sheet, and a map route preview.
- **Foreground & background tracking** — journeys keep recording while the app runs in the foreground with a service notification (via `flutter_foreground_task`).
- **Smart sessions** — automatic detection of stops, total distance, duration, average and max speed per trip.
- **Session history** — browse past sessions with a detail screen showing the route map, timeline, and stop overview.
- **Charts & analytics** — activity heatmap, daily distance chart, distance trend, moving vs stopped time, with selectable date ranges.
- **AI weekly insights** — powered by [Groq](https://groq.com). Each week's data is summarized into a warm 3-paragraph story with highlights. Falls back to a local summary when no API key is configured.
- **Accounts** — Firebase Authentication (email/password and Google Sign-In), with sessions synced to Cloud Firestore.
- **Onboarding, dark/light themes, and settings** — profile, appearance, tracking preferences, and data management screens.

## Tech Stack

- **Flutter** (Dart SDK ^3.13)
- **State management & routing** — [GetX](https://pub.dev/packages/get) + [go_router](https://pub.dev/packages/go_router)
- **Maps & location** — [flutter_map](https://pub.dev/packages/flutter_map), [latlong2](https://pub.dev/packages/latlong2), [geolocator](https://pub.dev/packages/geolocator)
- **Backend** — [Firebase](https://firebase.google.com) (Core, Auth, Cloud Firestore) + [google_sign_in](https://pub.dev/packages/google_sign_in)
- **Local storage** — [Hive](https://pub.dev/packages/hive) (sessions, location points, AI insights)
- **Charts** — [fl_chart](https://pub.dev/packages/fl_chart)
- **Other** — `http`, `intl`, `uuid`, `connectivity_plus`, `permission_handler`, `flutter_local_notifications`

## Getting Started

### Prerequisites

- Flutter SDK (^3.13) — see [Flutter installation](https://docs.flutter.dev/get-started/install)
- A Firebase project (for authentication and sync)

### Setup

1. Clone the repository:

   ```sh
   git clone https://github.com/AbdulRaheem4340/lifemap.git
   cd lifemap
   ```

2. Install dependencies:

   ```sh
   flutter pub get
   ```

3. Configure Firebase:
   - Add your platform config files from the Firebase console (`google-services.json` for Android, `GoogleService-Info.plist` for iOS/macOS).
   - Enable the Email/Password and Google sign-in providers in Firebase Authentication.
   - Create a Firestore database with rules that allow signed-in users to read/write their own data.

4. Add your Groq API key:
   - Open `lib/services/ai_service.dart`.
   - Replace the `_grokApiKey` placeholder with your key from [Groq Console](https://console.groq.com/keys):
     ```dart
     static const String _grokApiKey = 'YOUR_ACTUAL_KEY';
     ```
   - Without a valid key the app automatically uses a local, offline summary generator.

5. Run the app:

   ```sh
   flutter run
   ```

## Project Structure

```
lib/
├── core/              # App-wide wiring: bindings, constants, routes, theme, storage, utils
├── features/          # Feature screens & controllers
│   ├── ai_summary/    # AI weekly insights (Groq-powered)
│   ├── auth/          # Login / signup
│   ├── charts/        # Analytics, heatmaps, trending
│   ├── dashboard/     # Home dashboard
│   ├── onboarding/    # First-run onboarding
│   ├── session/       # Session detail & history
│   ├── settings/      # App settings
│   ├── splash/        # Launch screen
│   └── tracking/      # Live tracking, map, stats
├── models/            # Session, LocationPoint, AIInsight, UserProfile
├── repositories/      # Session, location, user data access
├── services/          # AI, geocoding, location, notifications, sync, foreground service
└── widgets/           # Reusable clippers, painters, UI pieces
```

## License

This project is provided for educational and personal use.

## Developer

Abdul Raheem