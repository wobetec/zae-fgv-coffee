// lib/components/section_with_label.dart

import 'package:flutter/material.dart';
import '../constants.dart';

class SectionWithLabel extends StatelessWidget {
  final String label;
  final String content;

  const SectionWithLabel({
    Key? key,
    required this.label,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 9),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: secondaryColor, width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Positioned(
            left: 10,
            top: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF80869A),
                  fontFamily: 'Roboto-Regular',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
