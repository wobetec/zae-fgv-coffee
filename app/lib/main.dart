// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/user_page.dart';
import 'pages/home_app_page.dart';
import 'pages/my_favorite_page.dart';
import 'pages/signin_adm_page.dart';
import 'pages/admin_profile_page.dart';
import 'pages/reports_page.dart';
import 'pages/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Carrega as variáveis de ambiente do arquivo .env
  await dotenv.load(fileName: path.join('.env'));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Solicita permissão para notificações
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Usuário concedeu permissão para notificações.');
  } else {
    print('Usuário não concedeu permissão para notificações.');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Método para verificar o status de login e o tipo de usuário
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
            // Enquanto verifica o status de login, exibe um indicador de progresso
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data == 'user') {
              // Usuário está logado como usuário regular, vai para a HomeAppPage
              return HomeAppPage();
            } else if (snapshot.data == 'admin') {
              // Usuário está logado como administrador, vai para AdminProfilePage
              return AdminProfilePage();
            } else {
              // Usuário não está logado, vai para a página inicial
              return HomePage();
            }
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/user': (context) => UserPage(),
        '/home_app': (context) => HomeAppPage(),
        '/my_favorite': (context) => MyFavoritePage(),
        '/signin_admin': (context) => SignInAdminPage(),
        '/adminProfile': (context) => AdminProfilePage(),
        '/reports': (context) => ReportsPage(),
      },
    );
  }
}
