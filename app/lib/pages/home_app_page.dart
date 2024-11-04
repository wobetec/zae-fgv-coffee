import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/item_card.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'user_page.dart';
import 'vending_machine_page.dart'; // Importa a nova página

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

  // Dados de exemplo para a lista
  final List<Map<String, dynamic>> _items = List.generate(10, (index) {
    return {
      'title': 'Vending Machine ${index + 1}',
      'subtitle': 'Categoria ${index + 1}',
      'imageUrl': '', // Substitua por URLs reais se disponível
      'rating': 5.0,
    };
  });

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      // Navegar para a página de perfil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFFF5722);
    final textColor = Color(0xFF232323);

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
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ItemCard(
            title: item['title'],
            subtitle: item['subtitle'],
            imageUrl: item['imageUrl'],
            rating: item['rating'],
            onTap: () {
              // Navegar para a página da máquina de venda selecionada
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VendingMachinePage(
                    vendingMachineData: item,
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
