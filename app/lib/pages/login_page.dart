import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true, // Oculta a senha
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Usuário logado!');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
