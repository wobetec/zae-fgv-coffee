// lib/pages/admin_profile_page.dart

import 'package:flutter/material.dart';
import 'reports_page.dart';
import 'admin_vending_machine_page.dart';
import 'login_page.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  String adminName = 'Marcelo';
  String adminEmail = 'marcelo@gmail.com';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFFF5722);
    final textColor = Color(0xFF232323);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 24,
            color: textColor,
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Header com o texto 'Admin'
          Container(
            width: double.infinity,
            color: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Text(
              'Admin',
              style: TextStyle(
                fontSize: 24,
                color: textColor,
                fontFamily: 'Roboto-SemiBold',
              ),
            ),
          ),
          // Cartão de Perfil
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFE2E2E2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                // Placeholder para a imagem do perfil
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 16),
                // Nome e Email do Administrador
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adminName,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Roboto-SemiBold',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      adminEmail,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Lista de Opções
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'Reports',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontFamily: 'Roboto-SemiBold',
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReportsPage()),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Vending Machines',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontFamily: 'Roboto-SemiBold',
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navegar para a página de vending machines do administrador
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminVendingMachinePage(),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: textColor),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontFamily: 'Roboto-SemiBold',
                    ),
                  ),
                  onTap: () {
                    // Lógica para sair da conta e retornar à tela de login
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
