import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart'; // Arquivo de configuração com a baseUrl
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Para verificar conectividade
import 'dart:io'; // Necessário para SocketException
import 'components/custom_input_field.dart';
import 'components/custom_button.dart';
import 'home_app_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controladores para os campos de entrada
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Indicador de carregamento

  // Método para verificar a conectividade de rede
  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('Sem conexão de rede.');
      _showDialog('Erro de Rede', 'Sem conexão de rede disponível.');
      return;
    } else {
      print('Conexão de rede disponível.');
    }
  }

  // Método para registrar o usuário
  // Future<void> _register() async {
  //   await _checkConnectivity(); // Verifica a conectividade antes do cadastro

  //   setState(() {
  //     _isLoading = true; // Exibe o indicador de carregamento
  //   });

  //   String username = _usernameController.text.trim();
  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text;

  //   if (username.isEmpty || email.isEmpty || password.isEmpty) {
  //     _showDialog('Erro', 'Todos os campos são obrigatórios.');
  //     setState(() {
  //       _isLoading = false; // Oculta o indicador de carregamento
  //     });
  //     return;
  //   }

  //   Map<String, String> data = {
  //     'username': username,
  //     'email': email,
  //     'password': password,
  //   };

  //   try {
  //     print('Enviando requisição de cadastro para o servidor...');
  //     print('Dados enviados: ${json.encode(data)}');

  //     final response = await http
  //         .post(
  //           Uri.parse('${Config.baseUrl}/auth/signup'),
  //           headers: {'Content-Type': 'application/json'},
  //           body: json.encode(data),
  //         )
  //         .timeout(Duration(seconds: 10), onTimeout: () {
  //       throw Exception('Conexão expirou');
  //     });

  //     print('Status Code: ${response.statusCode}');
  //     print('Resposta do servidor: ${response.body}');

  //     if (response.statusCode == 201) {
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
  //     }
  //     else {
  //       var responseData = json.decode(response.body);
  //       String errorMessage =
  //           responseData['error'] ?? 'Erro ao cadastrar usuário.';
  //       _showDialog('Erro', errorMessage);
  //     }
  //   } catch (e) {
  //     print('Erro durante o cadastro: $e');
  //     if (e is SocketException) {
  //       print('SocketException: ${e.message}');
  //       _showDialog('Erro',
  //           'Não foi possível conectar ao servidor. Verifique sua conexão.');
  //     } else {
  //       _showDialog('Erro', 'Ocorreu um erro. Detalhes: $e');
  //     }
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Oculta o indicador de carregamento
  //     });
  //   }
  // }

  Future<void> _register() async {
  setState(() {
    _isLoading = true;
  });

  String username = _usernameController.text.trim();
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (username.isEmpty || email.isEmpty || password.isEmpty) {
    _showDialog('Erro', 'Todos os campos são obrigatórios.');
    setState(() {
      _isLoading = false;
    });
    return;
  }

  // Simula um cadastro bem-sucedido
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', 'token_fake');
  await prefs.setString('username', username);
  await prefs.setString('email', email);
  await prefs.setString('userType', 'user');

  // Navega para a HomeAppPage
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomeAppPage()),
  );

  setState(() {
    _isLoading = false;
  });
}


  // Método para exibir diálogos de erro ou sucesso
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
    // Limpa os controladores ao descartar o widget
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define as cores para reutilização
    final primaryColor = Color(0xFFFFFFFF);
    final accentColor = Color(0xFFFF5722);
    final textColor = Color(0xFF000000);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Sign Up',
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
            // Campo de Nome de Usuário
            CustomInputField(
              controller: _usernameController,
              label: 'User',
            ),
            SizedBox(height: 20),
            // Campo de Email
            CustomInputField(
              controller: _emailController,
              label: 'Email',
            ),
            SizedBox(height: 20),
            // Campo de Senha
            CustomInputField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 30),
            // Botão de Cadastro
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
                    text: 'Sign Up',
                    onPressed: _register,
                    backgroundColor: accentColor,
                    textColor: Colors.white,
                  ),
            SizedBox(height: 20),
            // Texto com "Already have an account? Sign In."
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                    color: textColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign In.',
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
