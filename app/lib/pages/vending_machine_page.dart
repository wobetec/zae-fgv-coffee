// lib/pages/vending_machine_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'product_page.dart';
import 'components/vending_machine_card.dart';
import 'package:namer_app/api/vending_machine.dart';

class VendingMachinePage extends StatefulWidget {
  final Map<String, dynamic> productData;

  const VendingMachinePage({Key? key, required this.productData})
      : super(key: key);

  @override
  _VendingMachinePageState createState() => _VendingMachinePageState();
}

class _VendingMachinePageState extends State<VendingMachinePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.productData;
    final stocks = product["stock"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF232323)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          product['title'] ?? product['prod_name'] ?? 'Product',
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF232323),
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                final stock = stocks[index];
                return VendingMachineCard(
                  name: stock["vending_machine"]['vm_id'],
                  floor: stock["vending_machine"]['vm_floor'].toString(),
                  stockQuantity: stock['stock_quantity'].toString(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          productData: product,
                          stockData: stock,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
