// lib/pages/admin_vending_machine_detail_page.dart

import 'package:flutter/material.dart';

class AdminVendingMachineDetailPage extends StatelessWidget {
  final Map<String, dynamic> vendingMachineData;

  const AdminVendingMachineDetailPage({Key? key, required this.vendingMachineData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFFF5722);
    final textColor = Color(0xFF232323);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          vendingMachineData['name'] ?? 'Vending Machine',
          style: TextStyle(
            fontSize: 24,
            color: textColor,
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Seção OWNER
          Positioned(
            left: 15,
            right: 15,
            top: 20,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 9),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE2E2E2), width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    vendingMachineData['owner'] ?? 'Nome do Proprietário',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'OWNER',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF80869A),
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Seção ADDITIONAL INFORMATION
          Positioned(
            left: 15,
            right: 15,
            top: 150,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 9),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE2E2E2), width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    vendingMachineData['additionalInfo'] ?? 'Informações adicionais sobre a vending machine.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'ADDITIONAL INFORMATION',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF80869A),
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botão BLOCK
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Cor laranja padrão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                // Simula o bloqueio da vending machine e imprime a mensagem
                print('A vending machine ${vendingMachineData['name']} foi bloqueada');
                // Opcional: Exibir uma mensagem de confirmação ao administrador
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Vending Machine Bloqueada'),
                    content: Text('A vending machine ${vendingMachineData['name']} foi bloqueada com sucesso.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Block',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontFamily: 'Roboto-Medium',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
