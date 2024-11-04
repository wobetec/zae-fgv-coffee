import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'admin_profile_page.dart';

class SignInAdminPage extends StatefulWidget {
  @override
  State<SignInAdminPage> createState() => _SignInAdminPageState();
}

class _SignInAdminPageState extends State<SignInAdminPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  // Authentication code remains commented for future testing
  // Future<void> _loginAsAdmin() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   String username = _usernameController.text.trim();
  //   String password = _passwordController.text;

  //   if (username.isEmpty || password.isEmpty) {
  //     _showDialog('Error', 'All fields are required.');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return;
  //   }

  //   // Data for the request
  //   Map<String, String> data = {
  //     'username': username,
  //     'password': password,
  //   };

  //   try {
  //     // Send POST request to the admin login endpoint
  //     final response = await http.post(
  //       Uri.parse('${Config.baseUrl}/auth/admin/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(data),
  //     );

  //     if (response.statusCode == 200) {
  //       var responseData = json.decode(response.body);
  //       String token = responseData['token'];

  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('authToken', token);
  //       await prefs.setString('userType', 'admin');

  //       // Navigate to the admin page or dashboard
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => AdminProfilePage()),
  //       );
  //     } else {
  //       // Handle errors
  //       var responseData = json.decode(response.body);
  //       String errorMessage = responseData['error'] ?? 'Incorrect username or password.';
  //       _showDialog('Error', errorMessage);
  //     }
  //   } catch (e) {
  //     _showDialog('Error', 'An error occurred. Please try again.');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _loginAsAdmin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a successful admin login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', 'dummy_token');
    await prefs.setString('userType', 'admin');

    // Navigate to the admin profile page
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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Updated build method
  @override
  Widget build(BuildContext context) {
    // Define colors for reuse
    final primaryColor = Color(0xFFFFFFFF);
    final accentColor = Color(0xFFFF5722);
    final textColor = Color(0xFF000000);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Sign In as Admin',
          style: TextStyle(
            color: textColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username field
            CustomInputField(
              controller: _usernameController,
              label: 'Username',
            ),
            SizedBox(height: 20),
            // Password field
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
                    backgroundColor: accentColor,
                    textColor: Colors.white,
                  ),
          ],
        ),
      ),
    );
  }
}
