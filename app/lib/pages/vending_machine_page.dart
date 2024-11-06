// lib/pages/vending_machine_page.dart

import 'package:flutter/material.dart';
import 'product_page.dart';
import 'components/vending_machine_card.dart';

class VendingMachinePage extends StatefulWidget {
  final Map<String, dynamic> productData;

  const VendingMachinePage({Key? key, required this.productData})
      : super(key: key);

  @override
  _VendingMachinePageState createState() => _VendingMachinePageState();
}

class _VendingMachinePageState extends State<VendingMachinePage> {
  late List<Map<String, dynamic>> vendingMachines;

  @override
  void initState() {
    super.initState();
    _loadVendingMachines();
  }

  // Função para carregar as vending machines que possuem o produto selecionado
  void _loadVendingMachines() {
    // Dados de exemplo das vending machines
    vendingMachines = List.generate(5, (index) {
      return {
        'id': index,
        'name': 'Vending Machine ${index + 1}',
        'floor': 'Andar ${index + 1}',
        'product': widget.productData,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.productData;

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
          'Máquinas com ${product['title']}',
          style: TextStyle(
            fontSize: 20,
            color: const Color(0xFF232323),
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: vendingMachines.length,
        itemBuilder: (context, index) {
          final vendingMachine = vendingMachines[index];
          return VendingMachineCard(
            name: vendingMachine['name'],
            floor: vendingMachine['floor'],
            onTap: () {
              // Navegar para a página do produto na vending machine selecionada
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    productData: product,
                    vendingMachineData: vendingMachine,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
