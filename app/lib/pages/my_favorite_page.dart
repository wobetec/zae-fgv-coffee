// lib/pages/my_favorite_page.dart

import 'package:flutter/material.dart';

class MyFavoritePage extends StatelessWidget {
  const MyFavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2E2E2),
      body: Center(
        child: Text('My Favorites Page'),
      ),
    );
  }
}
