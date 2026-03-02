import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides access to environment variables loaded from `.env`.
class EnvConfig {
  EnvConfig._();

  /// Loads the `.env` file. Must be called before accessing any values.
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  /// Returns the Coinalyze API key.
  static String get coinalyzeApiKey =>
      dotenv.env['COINALYZE_API_KEY'] ?? '';
}
