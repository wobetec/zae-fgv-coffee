// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(); // Usando 'username'
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showDialog('Erro', 'Todos os campos são obrigatórios.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Dados para a requisição
    Map<String, String> data = {
      'username': username,
      'password': password,
    };

    try {
      // Enviando a requisição POST para o endpoint de login
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Login bem-sucedido, extrai o token
        var responseData = json.decode(response.body);
        String token = responseData['token'];

        // Armazena o token localmente
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        // Navega para a UserPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else {
        // Trata erros
        var responseData = json.decode(response.body);
        String errorMessage = responseData['error'] ?? 'Nome de usuário ou senha incorretos.';
        _showDialog('Erro', errorMessage);
      }
    } catch (e) {
      _showDialog('Erro', 'Ocorreu um erro. Tente novamente.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  // Método build atualizado
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Login'),
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
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
