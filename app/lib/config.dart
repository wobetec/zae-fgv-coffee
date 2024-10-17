import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String baseUrl = 'http://${dotenv.env['DJANGO_HOST'] ?? 'localhost'}:${dotenv.env['DJANGO_PORT'] ?? '8000'}';
  static final String vapidKey = "BIECtojqtRmnWZ3yPD0UfDxKExsRBNyIWNZX6sTjULvH0E7ADF6hsfTb4mC-ms2A_UqBPUBYDy1D9VXvk-lAWSc";
}
