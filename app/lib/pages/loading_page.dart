// lib/pages/loading_page.dart

import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Adjust if needed
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/loading_coffee.gif', // Use your actual GIF path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
