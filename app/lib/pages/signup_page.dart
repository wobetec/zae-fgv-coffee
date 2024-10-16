// lib/pages/signup_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart'; // Arquivo de configuração com a baseUrl
import 'package:shared_preferences/shared_preferences.dart';
import 'user_page.dart'; // Importamos a UserPage para navegar após o cadastro
import 'package:connectivity_plus/connectivity_plus.dart'; // Para verificar conectividade
import 'dart:io'; // Necessário para SocketException

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

  @override
  void initState() {
    super.initState();
    // Nenhuma ação necessária no initState para este caso
  }

  // Verifica a conectividade de rede
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
  Future<void> _register() async {
    await _checkConnectivity(); // Verifica a conectividade antes do cadastro

    setState(() {
      _isLoading = true; // Exibe o indicador de carregamento
    });

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showDialog('Erro', 'Todos os campos são obrigatórios.');
      setState(() {
        _isLoading = false; // Oculta o indicador de carregamento
      });
      return;
    }

    Map<String, String> data = {
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      print('Enviando requisição de cadastro para o servidor...');
      print('Dados enviados: ${json.encode(data)}');

      final response = await http
          .post(
            Uri.parse('${Config.baseUrl}/signup'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Conexão expirou');
      });

      print('Status Code: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');

      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        String token = responseData['token'];

        // Armazenar o token no SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        // Navegar para a UserPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else {
        var responseData = json.decode(response.body);
        String errorMessage =
            responseData['error'] ?? 'Erro ao cadastrar usuário.';
        _showDialog('Erro', errorMessage);
      }
    } catch (e) {
      print('Erro durante o cadastro: $e');
      if (e is SocketException) {
        print('SocketException: ${e.message}');
        _showDialog('Erro',
            'Não foi possível conectar ao servidor. Verifique sua conexão.');
      } else {
        _showDialog('Erro', 'Ocorreu um erro. Detalhes: $e');
      }
    } finally {
      setState(() {
        _isLoading = false; // Oculta o indicador de carregamento
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }
}
