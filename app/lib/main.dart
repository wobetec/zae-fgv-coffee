// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/user_page.dart';
import 'pages/home_app_page.dart';
import 'pages/my_favorite_page.dart';
import 'pages/admin_profile_page.dart';
import 'pages/reports_page.dart';
import 'pages/constants.dart';
import 'pages/main_screen.dart';
import 'pages/loading_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Load environment variables from the .env file
  await dotenv.load(fileName: path.join('.env'));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission for notifications.');
  } else {
    print('User did not grant permission for notifications.');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Method to check login status and user type
  Future<String> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    String? userType = prefs.getString('userType');
    if (token != null && userType != null) {
      return userType;
    } else {
      return 'none';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAE Coffee',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      home: FutureBuilder<String>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking login status, display a progress indicator
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data == 'user') {
              // User is logged in as a regular user, navigate to MainScreen
              return MainScreen();
            } else if (snapshot.data == 'admin') {
              // User is logged in as admin, navigate to AdminProfilePage
              return AdminProfilePage();
            } else {
              // User is not logged in, navigate to the HomePage
              return HomePage();
            }
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/user': (context) => UserPage(),
        '/home_app': (context) => HomeAppPage(username: 'User'),
        '/my_favorite': (context) => MyFavoritePage(),
        '/adminProfile': (context) => AdminProfilePage(),
        '/reports': (context) => ReportsPage(),
        '/loading': (context) => LoadingPage(),
      },
    );
  }
}
