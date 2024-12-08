// lib/components/section.dart

import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final String content;

  const Section({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xff80869a),
            fontFamily: 'Roboto-Regular',
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffe2e2e2), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xff000000),
              fontFamily: 'Roboto-Regular',
            ),
          ),
        ),
      ],
    );
  }
}
