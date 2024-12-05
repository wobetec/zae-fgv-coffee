// lib/pages/product_page.dart

import 'package:flutter/material.dart';
import 'user_page.dart';
import 'home_app_page.dart';
import 'components/custom_button.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'components/product_image.dart';
import 'components/star_rating.dart';
import 'components/favorite_button.dart';
import 'components/section.dart';
import 'constants.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> productData;
  final Map<String, dynamic> vendingMachineData;

  const ProductPage({
    Key? key,
    required this.productData,
    required this.vendingMachineData,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double _currentRating = 0.0;
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.productData;
    final vendingMachine = widget.vendingMachineData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5722),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF232323)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          product['title'] ?? 'Product',
          style: TextStyle(
            fontSize: 20,
            color: const Color(0xFF232323),
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagem do Produto
            ProductImage(
              imageUrl: product['imageUrl'] ?? '',
            ),
            // Detalhes do Produto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título do Produto
                  Text(
                    product['title'] ?? 'Título do Produto',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Roboto-SemiBold',
                    ),
                  ),
                  SizedBox(height: 8),
                  // Categoria ou Subtítulo
                  Text(
                    product['subtitle'] ?? 'Categoria do Produto',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                  SizedBox(height: 16),
                  // Avaliação e Favorito
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avaliação com Estrelas
                      StarRating(
                        rating: _currentRating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                          // Opcional: Enviar a avaliação para o backend
                        },
                      ),
                      // Botão de Favorito
                      FavoriteButton(
                        isFavorited: _isFavorited,
                        onPressed: () {
                          setState(() {
                            _isFavorited = !_isFavorited;
                          });
                          // Opcional: Atualizar favoritos no backend
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Seção de Descrição
                  Section(
                    title: 'Description',
                    content:
                        product['description'] ?? 'Descrição do produto aqui.',
                  ),
                  SizedBox(height: 16),
                  // Seção de Informações Nutricionais
                  Section(
                    title: 'Nutritional Information',
                    content: product['nutrition'] ??
                        'Informações nutricionais aqui.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 80), // Espaço para o botão de pedido
          ],
        ),
      ),
      // Botão de Pedido
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomButton(
          text: 'Order',
          onPressed: () {
            // Simula a compra
            print('Produto ${product['title']} foi comprado');
            // Exibe uma mensagem de confirmação
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Compra realizada'),
                content: Text('Você comprou o produto ${product['title']}.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
          backgroundColor:
              primaryColor,
          textColor: Colors.white,
        ),
      ),
      // Rodapé
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeAppPage(username: 'User')),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserPage()),
            );
          }
        },
      ),
    );
  }
}
