// lib/components/favorite_button.dart

import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback onPressed;

  const FavoriteButton({
    Key? key,
    required this.isFavorited,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : Colors.grey,
      ),
      iconSize: 30,
      onPressed: onPressed,
    );
  }
}
