// lib/pages/home_app_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/product_card.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'user_page.dart';
import 'vending_machine_page.dart';
import 'constants.dart';

class HomeAppPage extends StatefulWidget {
  const HomeAppPage({Key? key}) : super(key: key);

  @override
  _HomeAppPageState createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Função para carregar os dados do usuário do SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  int _currentIndex = 0;

  // Dados de exemplo para a lista de produtos
  final List<Map<String, dynamic>> _products = List.generate(10, (index) {
    return {
      'title': 'Produto ${index + 1}',
      'subtitle': 'Categoria ${index + 1}',
      'imageUrl': '', // Substitua por URLs reais se disponível
      'rating': 4.5, // Exemplo de avaliação
      'vendingMachineId': index % 3, // Exemplo de ID da máquina de venda
    };
  });

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      // Navegar para a página de perfil do usuário
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Olá $username,\nO que você está procurando?',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ProductCard(
            title: product['title'],
            subtitle: product['subtitle'],
            imageUrl: product['imageUrl'],
            rating: product['rating'],
            onTap: () {
              // Navegar para a máquina de venda que possui o produto selecionado
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VendingMachinePage(
                    productData: product,
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
