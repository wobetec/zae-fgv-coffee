// lib/pages/order_history_page.dart

import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for Order History here
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Color(0xFFFF5722),
      ),
      body: Center(
        child: Text('Order History Page'),
      ),
    );
  }
}
