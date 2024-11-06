// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'components/user_admin_switch.dart';
import 'constants.dart';
import 'home_app_page.dart';
import 'signin_adm_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool isAdmin = false; // Switch state

  // Function to login as a regular user
  Future<void> _loginAsUser() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog('Error', 'Please fill in all fields.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Simulate successful login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', 'dummy_token');
    await prefs.setString('username', 'User');
    await prefs.setString('email', email);
    await prefs.setString('userType', 'user');

    // Navigate to HomeAppPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeAppPage()),
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
  void initState() {
    super.initState();
    isAdmin = false; // Ensure the switch starts on 'User'
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Updated build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign In', style: TextStyle(color: textColor)),
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
                if (val) {
                  // Navigate to SignInAdminPage when switched to Admin
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInAdminPage()),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            // Email and Password fields
            CustomInputField(
              controller: _emailController,
              label: 'Email',
            ),
            SizedBox(height: 20),
            CustomInputField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 30),
            // Sign In button
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
                    text: 'Sign In',
                    onPressed: _loginAsUser,
                    backgroundColor: primaryColor,
                    textColor: Colors.white,
                  ),
            SizedBox(height: 20),
            // Sign Up option
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: textColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up.',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
