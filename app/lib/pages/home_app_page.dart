// lib/pages/home_app_page.dart

import 'package:flutter/material.dart';
import 'components/product_card.dart';
import 'vending_machine_page.dart';
import 'constants.dart';

class HomeAppPage extends StatefulWidget {
  final String username;

  const HomeAppPage({Key? key, required this.username}) : super(key: key);

  @override
  _HomeAppPageState createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  // Sample data for the product list
  final List<Map<String, dynamic>> _products = List.generate(10, (index) {
    return {
      'title': 'Product ${index + 1}',
      'subtitle': 'Category ${index + 1}',
      'imageUrl': '', // Replace with real URLs if available
      'rating': 4.5, // Sample rating
      'vendingMachineId': index % 3, // Sample vending machine ID
    };
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('HomeAppPage'),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductCard(
          title: product['title'],
          subtitle: product['subtitle'],
          imageUrl: product['imageUrl'],
          rating: product['rating'],
          onTap: () {
            // Navigate to the vending machine page
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
    );
  }
}
