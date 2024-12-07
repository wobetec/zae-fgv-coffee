// lib/pages/home_app_page.dart

import 'package:flutter/material.dart';
import 'components/product_card.dart';
import 'vending_machine_page.dart';
import 'constants.dart';
import 'package:namer_app/api/product.dart';
import 'package:namer_app/api/vending_machine.dart';

class HomeAppPage extends StatefulWidget {
  final String username;

  const HomeAppPage({Key? key, required this.username}) : super(key: key);

  @override
  _HomeAppPageState createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    List<dynamic> products = await Product.getProducts();
    List<dynamic> vending_machines = await VendingMachine.getVendingMachines();
    print(vending_machines);

    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('HomeAppPage'),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductCard(
          title: product['prod_name'],
          subtitle: product['prod_description'],
          imageUrl: '',
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
