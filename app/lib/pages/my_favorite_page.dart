// lib/pages/my_favorite_page.dart

import 'package:flutter/material.dart';
import 'package:namer_app/api/product.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({Key? key}) : super(key: key);

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  bool isLoading = true;
  List<dynamic> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
  }

  Future<void> _loadFavoriteProducts() async {
    try {
      Product product = Product();
      final favorites = await product.getFavoriteProducts();
      setState(() {
        favoriteProducts = favorites;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos favoritos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2E2E2),
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Color(0xFFFF5722),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteProducts.isEmpty
              ? Center(child: Text('No favorite products found.'))
              : ListView.builder(
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final favorite = favoriteProducts[index];
                    // Aqui extraímos o produto do objeto 'favorite'
                    final product = favorite['product'];
                    final vendingMachine = favorite['vending_machine'];
                    return ListTile(
                      title: Text("Floor ${vendingMachine['vm_floor']} - ${product['prod_name']}" ),
                      subtitle: Text('Price: \$${product['prod_price'] ?? '--'}'),
                    );
                  },
                ),
    );
  }
}
