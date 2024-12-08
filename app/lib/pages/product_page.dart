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
import 'package:namer_app/api/product.dart';
import 'package:namer_app/api/purchase.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> productData;
  final Map<String, dynamic> stockData;

  const ProductPage({
    Key? key,
    required this.productData,
    required this.stockData,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double _currentRating = 0.0;
  bool _isFavorited = false;
  bool isLoading = true;
  Map<String, dynamic>? productDetails;

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
  }

  bool checkFavorite(List<dynamic> favorites) {
    final productData = widget.productData;

    for (dynamic favorite in favorites) {
      final String prodId = favorite["product"]["prod_id"];
      final String vmId = favorite["vending_machine"]["vm_id"];
      if (prodId == productData["prod_id"] && (vmId == productData["vm_id"])) {
        return true;
      }
    }
    return false;
  }

  Future<void> _loadFavoriteProducts() async {
    dynamic favorites = await Product.getFavoriteProducts();

    setState(() {
      _isFavorited = checkFavorite(favorites);
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    final productData = widget.productData;
    final machineData = widget.stockData;
    final productId = productData['prod_id'];
    final vmId = machineData['vending_machine']['vm_id'];

    try {
      if (_isFavorited) {
        await Product.removeFavoriteProduct(productId, vmId);
        setState(() {
          _isFavorited = false;
        });
      } else {
        await Product.addFavoriteProduct(productId, vmId);
        setState(() {
          _isFavorited = true;
        });
      }
    } catch (e) {
      print('Erro ao atualizar favoritos: $e');
    }
  }

  Future<void> _orderProduct() async {
    final product = widget.productData;
    final stock = widget.stockData;
    final productId = product['prod_id'];
    final vmId = stock["vending_machine"]['vm_id'];

    try {
      final result = await Purchase.purchase(vmId, [
        {'prod_id': productId, 'quantity': 1}
      ]);

      print('Produto ${product['prod_name']} comprado com sucesso!');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Compra realizada'),
          content: Text('Você comprou o produto ${product['prod_name']}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Erro ao comprar produto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.productData;
    final stock = widget.stockData;

    if (isLoading) {
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
            'Carregando...',
            style: TextStyle(
              fontSize: 20,
              color: const Color(0xFF232323),
              fontFamily: 'Roboto-SemiBold',
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final prodName = product['prod_name'];
    final prodDescription = product['prod_description'];
    final prodPrice = product['prod_price'];
    final stockQuant = stock["stock_quantity"];

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
          prodName,
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
            ProductImage(
              imageUrl: product['imageUrl'] ?? '',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    prodName,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Roboto-SemiBold',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: \$${prodPrice.toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto-Regular',
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'In stock: $stockQuant',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StarRating(
                        rating: _currentRating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                        },
                      ),
                      FavoriteButton(
                        isFavorited: _isFavorited,
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Section(
                    title: 'Description',
                    content: prodDescription,
                  ),
                  SizedBox(height: 16),
                  Section(
                    title: 'Nutritional Information',
                    content: product['nutrition'] ??
                        'Informações nutricionais não disponíveis.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomButton(
          text: 'Order',
          onPressed: _orderProduct,
          backgroundColor: primaryColor,
          textColor: Colors.white,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeAppPage(username: 'User'),
              ),
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
