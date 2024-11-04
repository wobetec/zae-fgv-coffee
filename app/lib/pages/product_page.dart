import 'package:flutter/material.dart';
import 'user_page.dart';
import 'home_app_page.dart';
import 'components/custom_button.dart'; // Importe o seu componente de botão

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductPage({Key? key, required this.productData}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final product = widget.productData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Imagem do Produto (Placeholder)
          Positioned(
            left: 0,
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: 298,
            child: Container(
              color: const Color(0xffd9d9d9),
              child: Center(
                child: Text(
                  'IMAGEM DO PRODUTO',
                  style: TextStyle(
                    fontSize: 28,
                    color: const Color(0xff000000),
                    fontFamily: 'Roboto-SemiBold',
                  ),
                ),
              ),
            ),
          ),
          // Botão de Voltar
          Positioned(
            left: 16,
            top: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: const Color(0xff000000)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Descrição
          Positioned(
            left: 15,
            right: 15,
            top: 342,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 9),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffe2e2e2), width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Descrição do produto aqui.',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xff000000),
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  child: Container(
                    color: const Color(0xffffffff),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'DESCRIPTION',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xff80869a),
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Informações Nutricionais
          Positioned(
            left: 15,
            right: 15,
            top: 503,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 9),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffe2e2e2), width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Informações nutricionais aqui.',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xff000000),
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  child: Container(
                    color: const Color(0xffffffff),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'NUTRITIONAL INFORMATION',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xff80869a),
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botão de Order usando o componente existente
          Positioned(
            left: 16,
            right: 16,
            bottom: 80,
            child: CustomButton(
              text: 'Order',
              onPressed: () {
                // Simula a compra e imprime a mensagem no terminal
                print('Produto ${product['title']} foi comprado');

                // Opcional: Exibir uma mensagem de confirmação ao usuário
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
            ),
          ),
          // Rodapé
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 66,
              decoration: BoxDecoration(
                color: const Color(0xffeef3fc),
                border: Border.all(color: const Color(0xffe2e2e2), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botão Home
                  GestureDetector(
                    onTap: () {
                      // Navegar para HomeAppPage
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeAppPage()),
                        (route) => false,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, color: const Color(0xff232323)),
                        SizedBox(height: 8),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff232323),
                            fontFamily: 'Roboto-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botão Profile
                  GestureDetector(
                    onTap: () {
                      // Navegar para UserPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserPage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle, color: const Color(0xffff5722)),
                        SizedBox(height: 8),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffff5722),
                            fontFamily: 'Roboto-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
