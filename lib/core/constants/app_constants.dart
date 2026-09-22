class AppConstants {
  AppConstants._();

  static const double stopDetectionRadiusMeters = 25.0;
  static const int stopDetectionDurationSeconds = 120;
  static const int highAccuracyIntervalSeconds = 5;
  static const int batterySaverIntervalSeconds = 30;
  static const double highAccuracyDistanceMeters = 10.0;
  static const double batterySaverDistanceMeters = 50.0;
    static const double stopMaxSpeedMps = 0.5;


  static const String lightTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String darkTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String tileAttribution = '© OpenStreetMap contributors';
  static const int aiMaxTokens = 500;
  static const String aiModel = 'gpt-4o-mini';

  static const String nominatimBaseUrl =
      'https://nominatim.openstreetmap.org/reverse';
  static const String nominatimUserAgent = 'LifeMap/1.0';

  static const String boxSessions = 'sessions';
  static const String boxLocationPoints = 'location_points';
  static const String boxAiInsights = 'ai_insights';
}

