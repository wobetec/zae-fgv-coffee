import 'dart:convert';

import 'endpoints/endpoint_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';


enum UserType { user, support }

class Auth {
  /*
  Handle the authentication of the user and manage the access token.
  */
  String? _token;
  EndPointAuth? _endPointAuth;
  UserType? _userType;
  String? _username;

  Auth._privateConstructor();

  static final Auth _instance = Auth._privateConstructor();

  factory Auth() {
    return _instance;
  }

  void initialize(EndPointAuth? endPointAuth, {bool force = false, bool resetToken = false}) {
    if (resetToken) _token = null;
    if (_endPointAuth == null || force) {
      _endPointAuth = endPointAuth;
    } else {
      _endPointAuth = EndPointAuth();
    }
  }

  void loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') == null) return;
    if (prefs.getString('username') == null) return;
    if (prefs.getInt('userType') == null) return;

    _token = prefs.getString('token');
    _username = prefs.getString('username');
    _userType = UserType.values[prefs.getInt('userType') ?? 0];
  }

  void saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _token!);
    prefs.setString('username', _username!);
    prefs.setInt('userType', _userType!.index);
  }

  void deleteState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
    prefs.remove('userType');
  }

  Future<void> login(String username, String password, UserType userType) async {
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

  Future<void> logout(String deviceId) async {
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

  Future<void> signup(String username, String email, String password) async {
    await _endPointAuth!.signup(username, email, password)
      .then((response) {
        if (response.statusCode == 201) {
          _token = jsonDecode(response.body)['token'];
          _username = username;
        } else {
          throw Exception('Failed to signup');
        }
      })
      .catchError((error) {
        throw Exception('Failed to signup');
      });
    _userType = UserType.user;
  }

  bool hasToken() {
    return _token != null;
  }

  Future<bool> checkToken() async {
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

  String? getToken() {
    return _token;
  }

  void setToken(String token) {
    _token = token;
  }

  UserType? getUserType() {
    return _userType;
  }

  void setUserType(UserType userType) {
    _userType = userType;
  }

  String? getUsername() {
    return _username;
  }
}
