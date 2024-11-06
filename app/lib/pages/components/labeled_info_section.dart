// lib/components/labeled_info_section.dart

import 'package:flutter/material.dart';
import '../constants.dart';

class LabeledInfoSection extends StatelessWidget {
  final String label;
  final String content;

  const LabeledInfoSection({
    Key? key,
    required this.label,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label da seção
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            label.toUpperCase(),
            style: sectionLabelTextStyle,
          ),
        ),
        SizedBox(height: 5),
        // Caixa de conteúdo
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: secondaryColor, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            content,
            style: sectionContentTextStyle,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
