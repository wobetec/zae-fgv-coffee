import 'package:flutter/material.dart';
import 'home_app_page.dart';
import 'product_page.dart';

class VendingMachinePage extends StatefulWidget {
  final Map<String, dynamic> vendingMachineData;

  const VendingMachinePage({Key? key, required this.vendingMachineData})
      : super(key: key);

  @override
  _VendingMachinePageState createState() => _VendingMachinePageState();
}

class _VendingMachinePageState extends State<VendingMachinePage> {
  @override
  Widget build(BuildContext context) {
    // Obter os dados da máquina de venda
    final vendingMachine = widget.vendingMachineData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffff5722),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xff232323)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          vendingMachine['title'] as String,
          style: TextStyle(
            fontSize: 24,
            color: const Color(0xff232323),
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: 10, // Substitua pelo número real de produtos
        itemBuilder: (context, index) {
          // Dados de exemplo dos produtos
          final product = {
            'title': 'Produto ${index + 1}',
            'subtitle': 'Categoria ${index + 1}',
            'rating': 5.0,
          };
          return GestureDetector(
            onTap: () {
              // Navegar para a página do produto selecionado
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(productData: product),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  // Placeholder para a imagem removida
                  Container(
                    width: 90,
                    height: 100,
                    color: Color(0xFFEEF3FC),
                    child: Icon(
                      Icons.fastfood,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Informações textuais
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'] as String,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF232323),
                                    fontFamily: 'Roboto-SemiBold',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  product['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF80869A),
                                    fontFamily: 'Roboto-Regular',
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      product['rating'].toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF80869A),
                                        fontFamily: 'Roboto-Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Ícone de seta
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
