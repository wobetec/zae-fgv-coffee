import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart'; // Importa a configuração com a baseUrl

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _username = '';
  bool _isLoading = true; // Indicador de carregamento

  // Método para buscar os dados do usuário
  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      // Token não encontrado, redireciona para o login após o frame atual
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    try {
      // Envia a requisição GET para verificar o token
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/auth/test_token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          _username = responseData['username'] ?? 'Usuário';
          _isLoading = false; // Oculta o indicador de carregamento
        });
      } else {
        // Token inválido ou expirado
        setState(() {
          _isLoading = false; // Oculta o indicador de carregamento
        });
        _showDialog('Erro', 'Sessão expirada. Faça login novamente.', onOk: () {
          _logout();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Oculta o indicador de carregamento
      });
      _showDialog('Erro', 'Ocorreu um erro. Tente novamente.');
    }
  }

  // Método para realizar o logout com confirmação
  void _logout() {
    _showConfirmationDialog();
  }

  void _performLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  // Método para exibir o diálogo de confirmação de logout
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmação'),
        content: Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              _performLogout(); // Realiza o logout
            },
            child: Text('Sair'),
          ),
        ],
      ),
    );
  }

  // Método para exibir diálogos de erro ou mensagem
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
    _fetchUserData(); // Busca os dados do usuário ao iniciar a página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página do Usuário'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'Bem-vindo, $_username!',
                style: TextStyle(fontSize: 24),
              ),
      ),
    );
  }
}
