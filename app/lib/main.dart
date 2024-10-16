// main.dart

import 'package:flutter/material.dart';
import 'pages/signup_page.dart';
import 'pages/login_page.dart';
import 'pages/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  await dotenv.load(fileName: path.join('.env'));
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Método para verificar o status de login
  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      title: 'App de Cadastro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto verifica o status de login, exibe um indicador de progresso
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.data == true) {
              // Usuário está logado, vai para a UserPage
              return UserPage();
            } else {
              // Usuário não está logado, vai para a página inicial
              return MyHomePage();
            }
          }
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/user': (context) => UserPage(), // Adicionamos a rota para UserPage
      },
    );
  }
}

// Página inicial com opções de login e cadastro
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de título
      appBar: AppBar(
        title: Text('ZAE Café'),
      ),
      // Conteúdo da página
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // Texto de boas-vindas
              'Bem-vindo ao ZAE Café!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              // Botão para ir para a página de cadastro
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Cadastrar'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              // Botão para ir para a página de login
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
