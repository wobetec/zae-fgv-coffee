import 'dart:convert';

import 'endpoints/endpoint_auth.dart';

class Auth {
  static String? _token;
  static EndPointAuth? _endPointAuth;

  static initialize(EndPointAuth? endPointAuth, {bool force = false, bool resetToken = false}) {
    if (resetToken) _token = null;
    if (_endPointAuth == null || force) {
      _endPointAuth = endPointAuth;
    } else {
      _endPointAuth = EndPointAuth();
    }
  }

  static Future<void> login(String username, String password) async {
    await _endPointAuth!.login(username, password)
      .then((response) {
        if (response.statusCode == 200) {
          _token = jsonDecode(response.body)['token'];
        } else {
          throw Exception('Failed to login');
        }
      })
      .catchError((error) {
        throw Exception('Failed to login');
      });
  }

  static Future<void> supportLogin(String username, String password) async {
    await _endPointAuth!.supportLogin(username, password)
      .then((response) {
        if (response.statusCode == 200) {
          _token = jsonDecode(response.body)['token'];
        } else {
          throw Exception('Failed to login');
        }
      })
      .catchError((error) {
        throw Exception('Failed to login');
      });
  }

  static Future<void> logout() async {
    if (_token != null) {
      await _endPointAuth!.logout(_token!)
        .then((response) {
          if (response.statusCode == 200) {
            _token = null;
          } else {
            throw Exception('Failed to logout');
          }
        })
        .catchError((error) {
          throw Exception('Failed to logout');
        });
    }
    else {
      throw Exception('No token');
    }
  }

  static Future<void> supportLogout() async {
    if (_token != null) {
      await _endPointAuth!.supportLogout(_token!)
        .then((response) {
          if (response.statusCode == 200) {
            _token = null;
          } else {
            throw Exception('Failed to logout');
          }
        })
        .catchError((error) {
          throw Exception('Failed to logout');
        });
    }
    else {
      throw Exception('No token');
    }
  }

  static Future<void> signup(String username, String email, String password) async {
    await _endPointAuth!.signup(username, email, password)
      .then((response) {
        if (response.statusCode == 200) {
          _token = jsonDecode(response.body)['token'];
        } else {
          throw Exception('Failed to signup');
        }
      })
      .catchError((error) {
        throw Exception('Failed to signup');
      });
  }

  static bool hasToken() {
    return _token != null;
  }

  static Future<bool> checkToken() async {
    if (_token != null) {
      return await _endPointAuth!.testToken(_token!)
        .then((response) {
          if (response.statusCode == 200) {
            return true;
          } else {
            return false;
          }
        })
        .catchError((error) {
          return false;
        });
    }
    return false;
  }

  static Future<bool> checkSupportToken() async {
    if (_token != null) {
      return await _endPointAuth!.supportTestToken(_token!)
        .then((response) {
          if (response.statusCode == 200) {
            return true;
          } else {
            return false;
          }
        })
        .catchError((error) {
          return false;
        });
    }
    return false;
  }

  static String? getToken() {
    return _token;
  }

  static void setToken(String token) {
    _token = token;
  }
}
