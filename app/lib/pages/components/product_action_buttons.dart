// lib/components/product_action_buttons.dart

import 'package:flutter/material.dart';
import '../constants.dart';

class ProductActionButtons extends StatelessWidget {
  final VoidCallback onBuyPressed;
  final VoidCallback onFavoritePressed;
  final bool isFavorited;

  const ProductActionButtons({
    Key? key,
    required this.onBuyPressed,
    required this.onFavoritePressed,
    required this.isFavorited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onBuyPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: Text('Comprar'),
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: primaryColor,
          ),
          onPressed: onFavoritePressed,
        ),
      ],
    );
  }
}
