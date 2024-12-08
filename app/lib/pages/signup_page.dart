// lib/pages/signup_page.dart

import 'package:flutter/material.dart';
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'constants.dart';
import 'main_screen.dart';

import 'package:namer_app/apis/apis.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for input fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // For hover effect on "Sign In" text
  bool _isHovering = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showDialog('Error', 'All fields are required.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      APIs().signup(username, email, password);
    } catch (e) {
      _showDialog('Error', 'Failed to sign up. Please try again.');
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

  // Method to show dialogs
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
    // Dispose the controllers when the widget is removed
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define maximum widths for input fields and buttons
    double maxInputFieldWidth = 800.0; // Input fields max width
    double maxButtonWidth = 500.0; // Buttons max width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: textColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Handles overflow on smaller screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username Field
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                child: CustomInputField(
                  controller: _usernameController,
                  label: 'Username',
                ),
              ),
              SizedBox(height: 20),
              // Email Field
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                child: CustomInputField(
                  controller: _emailController,
                  label: 'Email',
                ),
              ),
              SizedBox(height: 20),
              // Password Field
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                child: CustomInputField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
              ),
              SizedBox(height: 30),
              // Sign Up Button
              _isLoading
                  ? CircularProgressIndicator()
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxButtonWidth),
                      child: CustomButton(
                        text: 'Sign Up',
                        onPressed: _signup,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        width: double.infinity, // Button fills available width
                      ),
                    ),
              SizedBox(height: 20),
              // Sign In Option
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxInputFieldWidth),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Already have an account? ",
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
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              'Sign In.',
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
          ),
        ),
      ),
    );
  }
}
