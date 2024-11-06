// lib/components/product_image.dart

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffd9d9d9),
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
            )
          : Center(
              child: Text(
                'IMAGEM DO PRODUTO',
                style: TextStyle(
                  fontSize: 28,
                  color: const Color(0xff000000),
                  fontFamily: 'Roboto-SemiBold',
                ),
              ),
            ),
    );
  }
}
