class EndPoint {
  static const String baseUrl = 'http://localhost:8080/';

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
