import 'package:namer_app/config.dart';

class EndPoint {
  static String baseUrl = Config.baseUrl;

  Map<String, String> headers(String? token) {
    Map<String, String> headers_ = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers_['Authorization'] = 'Token $token';
    }

    return headers_;
  }
}
