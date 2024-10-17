import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String baseUrl = 'http://${dotenv.env['DJANGO_HOST'] ?? 'localhost'}:${dotenv.env['DJANGO_PORT'] ?? '8000'}';
}
