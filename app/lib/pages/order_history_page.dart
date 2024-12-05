// lib/pages/order_history_page.dart

import 'package:flutter/material.dart';
import 'constants.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Text('Order History Page'),
      ),
    );
  }
}
