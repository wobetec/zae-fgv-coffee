import 'package:http/http.dart';
import 'dart:convert';
import 'endpoint.dart';

class EndPointAuth extends EndPoint {
  Future<Response> login(String username, String password) async {
    final url = Uri.parse('${EndPoint.baseUrl}auth/login');

    final response = await post(
      url,
      headers: headers(null),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    return response;
  }

  Future<Response> supportLogin(String username, String password) async {
    final url = Uri.parse('${EndPoint.baseUrl}auth/support/login');

    final response = await post(
      url,
      headers: headers(null),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    return response;
  }

  Future<Response> signup(
    String username, String email, String password) async {
    final url = Uri.parse('${EndPoint.baseUrl}auth/signup');

    final response = await post(
      url,
      headers: headers(null),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  Future<Response> logout(String token, String deviceId) async {
    final url = Uri.parse('${EndPoint.baseUrl}auth/logout');

    final response = await post(
      url,
      headers: headers(token),
      body: jsonEncode({
        'device_id': deviceId,
      }),
    );
    return response;
  }

  Future<Response> supportLogout(String token, String deviceId) async {
    final url = Uri.parse('${EndPoint.baseUrl}auth/support/logout');

    final response = await post(
      url,
      headers: headers(token),
      body: jsonEncode({
        'device_id': deviceId,
      }),
    );
    return response;
  }

  Future<Response> testToken(String token) async {
    final url = Uri.parse('${EndPoint.baseUrl}auth/test_token');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }

  Future<Response> supportTestToken(String token) async {
    final url = Uri.parse('${EndPoint.baseUrl}auth/support/test_token');

    final response = await get(
      url,
      headers: headers(token),
    );
    return response;
  }
}
