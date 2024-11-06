// lib/pages/signin_adm_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'components/user_admin_switch.dart';
import 'constants.dart';
import 'admin_profile_page.dart';
import 'login_page.dart';

class SignInAdminPage extends StatefulWidget {
  @override
  State<SignInAdminPage> createState() => _SignInAdminPageState();
}

class _SignInAdminPageState extends State<SignInAdminPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool isAdmin = true; // Switch state

  Future<void> _loginAsAdmin() async {
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

    // Simulate successful admin login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', 'dummy_token');
    await prefs.setString('username', username);
    await prefs.setString('email', 'admin@example.com');
    await prefs.setString('userType', 'admin');

    // Navigate to AdminProfilePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminProfilePage()),
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
    isAdmin = true; // Ensure the switch starts on 'Admin'
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Updated build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sign In as Admin',
          style: TextStyle(
            color: textColor,
          ),
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
                if (!val) {
                  // Navigate to LoginPage when switched to User
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
            // Username and Password fields
            CustomInputField(
              controller: _usernameController,
              label: 'Username',
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
                    text: 'Sign In as Admin',
                    onPressed: _loginAsAdmin,
                    backgroundColor: primaryColor,
                    textColor: Colors.white,
                  ),
            // Option to switch back to User login is now handled by the switch
          ],
        ),
      ),
    );
  }
}
