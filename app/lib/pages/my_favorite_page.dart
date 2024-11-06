// lib/pages/my_favorite_page.dart

import 'package:flutter/material.dart';

class MyFavoritePage extends StatelessWidget {
  const MyFavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for My Favorites here
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Color(0xFFFF5722),
      ),
      body: Center(
        child: Text('My Favorites Page'),
      ),
    );
  }
}
