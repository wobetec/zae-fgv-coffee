// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'components/custom_button.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título
            Text(
              'ZAE Coffee',
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontFamily: 'Roboto-SemiBold',
              ),
            ),
            SizedBox(height: 20),
            // Imagem
            Image.asset(
              'assets/images/image_1293.png',
              width: 200,
              height: 140,
            ),
            SizedBox(height: 40),
            // Botão Sign In
            CustomButton(
              text: 'Sign In',
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              backgroundColor: secondaryColor,
              textColor: textColor,
            ),
            SizedBox(height: 20),
            // Botão Sign Up
            CustomButton(
              text: 'Sign Up',
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              backgroundColor: secondaryColor,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
