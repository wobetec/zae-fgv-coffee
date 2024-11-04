import 'package:flutter/material.dart';
import 'components/item_card.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'home_app_page.dart';
import 'user_page.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({Key? key}) : super(key: key);

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  int _currentIndex = 1; // Índice atual do BottomNavigationBar

  // Lista de favoritos (dados de exemplo)
  final List<Map<String, dynamic>> _favorites = List.generate(5, (index) {
    return {
      'title': 'Favorite Item ${index + 1}',
      'subtitle': 'Category ${index + 1}',
      'imageUrl': '', // Substitua por URLs reais se disponível
      'rating': 5.0,
    };
  });

  void _onNavBarTap(int index) {
    if (index == 0) {
      // Navegar para a HomeAppPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAppPage()),
      );
    } else if (index == 1) {
      // Navegar para a UserPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define as cores
    final primaryColor = Color(0xFFFF5722);
    final textColor = Color(0xFF232323);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorite',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final item = _favorites[index];
          return ItemCard(
            title: item['title'],
            subtitle: item['subtitle'],
            imageUrl: item['imageUrl'],
            rating: item['rating'],
            onTap: () {
              // Lidar com o clique no item
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
