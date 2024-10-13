import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    _scheduleNotification();
  }

  // Simula a chegada da notificação após 10 segundos
  void _scheduleNotification() {
    Future.delayed(Duration(seconds: 10), () {
      _showNotification();
    });
  }

  // Exibe a notificação como um AlertDialog
  void _showNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notificação de Produto Esgotado"),
          content: Text(
              "O produto Café Expresso está esgotado na vending machine VM-123!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o pop-up
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página do Usuário'),
      ),
      body: Center(
        child: Text(
          'Esta é a página genérica de Usuário.\nNotificacao em 10 segundos.',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
