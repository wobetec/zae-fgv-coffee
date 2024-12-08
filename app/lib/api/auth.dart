import 'dart:convert';

import 'endpoints/endpoint_auth.dart';

enum UserType { user, support }

class Auth {
  static String? _token;
  static EndPointAuth? _endPointAuth;
  static UserType? _userType;
  static String? _username;

  static initialize(EndPointAuth? endPointAuth,
      {bool force = false, bool resetToken = false}) {
    if (resetToken) _token = null;
    if (_endPointAuth == null || force) {
      _endPointAuth = endPointAuth;
    } else {
      _endPointAuth = EndPointAuth();
    }
  }

  static Future<void> login(String username, String password, UserType userType) async {
    if (userType == UserType.user) {
      await _endPointAuth!.login(username, password).then((response) {
        if (response.statusCode == 200) {
          _token = jsonDecode(response.body)['token'];
          _username = username;
        } else {
          throw Exception('Failed to login');
        }
      }).catchError((error) {
        throw Exception('Failed to login');
      });
    } else if (userType == UserType.support) {
      await _endPointAuth!.supportLogin(username, password).then((response) {
        if (response.statusCode == 200) {
          _token = jsonDecode(response.body)['token'];
          _username = username;
        } else {
          throw Exception('Failed to login');
        }
      }).catchError((error) {
        throw Exception('Failed to login');
      });
    }
    _userType = userType;
  }

  static Future<void> logout(String deviceId) async {
    if (_token != null) {
      if (_userType == UserType.user) {
        await _endPointAuth!.logout(_token!, deviceId).then((response) {
          if (response.statusCode == 200) {
            _token = null;
            _username = null;
          } else {
            throw Exception('Failed to logout');
          }
        }).catchError((error) {
          throw Exception('Failed to logout');
        });
      } else if (_userType == UserType.support) {
        await _endPointAuth!.supportLogout(_token!, deviceId).then((response) {
          if (response.statusCode == 200) {
            _token = null;
            _username = null;
          } else {
            throw Exception('Failed to logout');
          }
        }).catchError((error) {
          throw Exception('Failed to logout');
        });
      }
    } else {
      throw Exception('No token');
    }
  }

  static Future<void> signup(
      String username, String email, String password) async {
    await _endPointAuth!.signup(username, email, password).then((response) {
      if (response.statusCode == 201) {
        _token = jsonDecode(response.body)['token'];
        _username = username;
      } else {
        throw Exception('Failed to signup');
      }
    }).catchError((error) {
      throw Exception('Failed to signup');
    });
    _userType = UserType.user;
  }

  static bool hasToken() {
    return _token != null;
  }

  static Future<bool> checkToken() async {
    if (_token != null) {
      if (_userType == UserType.user) {
        return await _endPointAuth!.testToken(_token!).then((response) {
          if (response.statusCode == 200) {
            return true;
          } else {
            return false;
          }
        }).catchError((error) {
          return false;
        });
      } else if (_userType == UserType.support) {
        return await _endPointAuth!.supportTestToken(_token!).then((response) {
          if (response.statusCode == 200) {
            return true;
          } else {
            return false;
          }
        }).catchError((error) {
          return false;
        });
      }
    }
    return false;
  }

  static String? getToken() {
    return _token;
  }

  static void setToken(String token) {
    _token = token;
  }

  static UserType? getUserType() {
    return _userType;
  }

  static void setUserType(UserType userType) {
    _userType = userType;
  }

  static String? getUsername() {
    return _username;
  }
}
