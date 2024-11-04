import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'home_app_page.dart';
import 'admin_profile_page.dart';
import 'package:flutter_switch/flutter_switch.dart'; // Import the flutter_switch package

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(); // Using 'username'
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool isAdmin = false; // Variable to control the toggle switch state

  // Authentication code remains commented for future testing
  // Future<void> _login() async {
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
  //     // Send POST request to the login endpoint
  //     final response = await http.post(
  //       Uri.parse('${Config.baseUrl}/auth/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(data),
  //     );

  //     if (response.statusCode == 200) {
  //       var responseData = json.decode(response.body);
  //       String token = responseData['token'];
  //       String username = responseData['username'];
  //       String email = responseData['email'];

  //       // Store the token, username, and email locally
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('authToken', token);
  //       await prefs.setString('username', username);
  //       await prefs.setString('email', email);

  //       // Navigate to the UserPage
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeAppPage()),
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

    // Simulate a successful login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', 'dummy_token');
    await prefs.setString('username', username);
    await prefs.setString('email', 'user@example.com');
    await prefs.setString('userType', isAdmin ? 'admin' : 'user');

    // Navigate to the appropriate page
    if (isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminProfilePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAppPage()),
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

  // Updated build method
  @override
  Widget build(BuildContext context) {
    // Define colors for reuse
    final primaryColor = Color(0xFFFFFFFF);
    final accentColor = Color(0xFFFF5722);
    final textColor = Color(0xFF000000);
    final switchActiveColor = accentColor;
    final switchInactiveColor = Colors.grey.shade300;
    final switchToggleColor = Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(
            color: textColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        // Remove the IconButton for switching accounts
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.switch_account),
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/signin_admin');
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle Switch to select User or Admin
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'User',
                  style: TextStyle(
                    fontSize: 16,
                    color: isAdmin ? Colors.black : accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                FlutterSwitch(
                  width: 60.0,
                  height: 30.0,
                  valueFontSize: 12.0,
                  toggleSize: 20.0,
                  value: isAdmin,
                  borderRadius: 30.0,
                  padding: 4.0,
                  activeColor: switchActiveColor,
                  inactiveColor: switchInactiveColor,
                  onToggle: (val) {
                    setState(() {
                      isAdmin = val;
                    });
                  },
                ),
                SizedBox(width: 10),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 16,
                    color: isAdmin ? accentColor : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Email or Username field
            CustomInputField(
              controller: _usernameController,
              label: isAdmin ? 'Username' : 'Email',
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
                    text: 'Sign In',
                    onPressed: _login,
                    backgroundColor: accentColor,
                    textColor: Colors.white,
                  ),
            SizedBox(height: 20),
            // "Don't have an account? Sign Up." text for user login
            if (!isAdmin)
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
                          color: accentColor,
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
