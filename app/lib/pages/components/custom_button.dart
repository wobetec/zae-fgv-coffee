// lib/components/custom_button.dart

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double? width; // Added optional width parameter

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFE2E2E2),
    this.textColor = const Color(0xFF232323),
    this.width, // Initialize the width parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontFamily: 'Roboto-Medium',
        ),
      ),
    );

    if (width != null) {
      return SizedBox(
        width: width,
        child: button,
      );
    } else {
      return button;
    }
  }
}
