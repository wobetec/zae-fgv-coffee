// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'components/custom_button.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the maximum width for content
    double maxContentWidth = 400.0; // Adjust this value as needed

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxContentWidth,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'ZAE Coffee',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontFamily: 'Roboto-SemiBold',
                ),
              ),
              SizedBox(height: 20),
              // Image
              Image.asset(
                'assets/images/image_1293.png',
                width: 200,
                height: 140,
              ),
              SizedBox(height: 40),
              // Sign In Button
              SizedBox(
                width: double.infinity, // Allows the button to fill the available width
                child: CustomButton(
                  text: 'Sign In',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  backgroundColor: secondaryColor,
                  textColor: textColor,
                ),
              ),
              SizedBox(height: 20),
              // Sign Up Button
              SizedBox(
                width: double.infinity, // Allows the button to fill the available width
                child: CustomButton(
                  text: 'Sign Up',
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  backgroundColor: secondaryColor,
                  textColor: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
