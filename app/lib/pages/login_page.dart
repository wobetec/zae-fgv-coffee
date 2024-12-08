// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'components/user_admin_switch.dart';
import 'constants.dart';
import 'main_screen.dart';
import 'admin_profile_page.dart'; // Importamos a página de perfil do admin

import 'package:namer_app/api/auth.dart';
import 'package:namer_app/api/notification.dart' as my_notification;
import 'package:namer_app/fcm/fcm.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool isAdmin = false;
  bool _isHovering = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showDialog('Error', 'Please fill in all fields.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await Auth.login(
        username, 
        password, 
        isAdmin ? UserType.support : UserType.user
      );
      print('Logged OK');
      await my_notification.Notification.registerDevice(
        FCM.registrationId!,
        FCM.deviceType!,
        FCM.deviceId!,
      );
      print('Notification OK');
    } catch (e) {
      _showDialog('Error', 'Failed to sign in. Please try again.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Se isAdmin == true, vai para AdminProfilePage. Caso contrário, vai para MainScreen.
    if (isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminProfilePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showDialog(String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) {
                onOk();
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxInputFieldWidth = 800.0; 
    double maxButtonWidth = 500.0;

    final appBarTitle = isAdmin ? 'Sign In as Admin' : 'Sign In';
    final buttonText = isAdmin ? 'Sign In as Admin' : 'Sign In';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: UserAdminSwitch(
              isAdmin: isAdmin,
              onToggle: (val) {
                setState(() {
                  isAdmin = val;
                });
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                child: CustomInputField(
                  controller: _usernameController,
                  label: 'Username',
                ),
              ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                child: CustomInputField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxButtonWidth),
                      child: CustomButton(
                        text: buttonText,
                        onPressed: _login,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        width: double.infinity,
                      ),
                    ),
              if (!isAdmin) ...[
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: textColor,
                      ),
                      children: [
                        WidgetSpan(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) {
                              setState(() {
                                _isHovering = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _isHovering = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                'Sign Up.',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: _isHovering
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
