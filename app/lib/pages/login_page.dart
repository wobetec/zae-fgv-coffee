// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'components/user_admin_switch.dart';
import 'constants.dart';
import 'main_screen.dart';

import 'package:namer_app/api/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for user login
  final _userUsernameController = TextEditingController();
  final _userPasswordController = TextEditingController();

  // Controllers for admin login
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();

  bool _isLoading = false;
  bool isAdmin = false; // Switch state

  // For hover effect on "Sign Up" text
  bool _isHovering = false;

  // Function to login as a regular user
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String username = _userUsernameController.text.trim();
    String password = _userPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showDialog('Error', 'Please fill in all fields.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await Auth.login(username, password, isAdmin? UserType.support : UserType.user);
    } catch (e) {
      _showDialog('Error', 'Failed to sign in. Please try again.');
      // setState(() {
      //   _isLoading = false;
      // });
      // return;
    }

    // Navigate to MainScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );

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
    _userUsernameController.dispose();
    _userPasswordController.dispose();
    _adminUsernameController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define maximum widths for input fields and buttons
    double maxInputFieldWidth = 800.0; // Input fields max width
    double maxButtonWidth = 500.0;     // Buttons max width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isAdmin ? 'Sign In as Admin' : 'Sign In',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          // Switch in the AppBar
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
        child: SingleChildScrollView( // Handles overflow on smaller screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              // Conditional rendering based on isAdmin
              if (isAdmin) ...[
                // Admin login form
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                  child: CustomInputField(
                    controller: _adminUsernameController,
                    label: 'Username',
                  ),
                ),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                  child: CustomInputField(
                    controller: _adminPasswordController,
                    label: 'Password',
                    obscureText: true,
                  ),
                ),
              ] else ...[
                // User login form
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                  child: CustomInputField(
                    controller: _userUsernameController,
                    label: 'Username',
                  ),
                ),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                  child: CustomInputField(
                    controller: _userPasswordController,
                    label: 'Password',
                    obscureText: true,
                  ),
                ),
              ],
              SizedBox(height: 30),
              // Sign In button
              _isLoading
                  ? CircularProgressIndicator()
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxButtonWidth),
                      child: CustomButton(
                        text: isAdmin ? 'Sign In as Admin' : 'Sign In',
                        onPressed: _login,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        width: double.infinity, // Button fills available width
                      ),
                    ),
              if (!isAdmin) ...[
                SizedBox(height: 20),
                // Sign Up option for users
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
