class AppConstants {
  AppConstants._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://astro-backend-new-m37h.onrender.com/api',
  );
  static const String appName = 'Astro';
  static const String tagline = 'Vedic Astrology & Matchmaking';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const String kToken = 'astro_token';
  static const String kUser = 'astro_user';
  static const String kOnboarded = 'astro_onboarded';
}
