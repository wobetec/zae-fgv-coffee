// lib/pages/admin_vending_machine_page.dart

import 'package:flutter/material.dart';
import 'admin_vending_machine_detail_page.dart';

class AdminVendingMachinePage extends StatefulWidget {
  const AdminVendingMachinePage({Key? key}) : super(key: key);

  @override
  _AdminVendingMachinePageState createState() => _AdminVendingMachinePageState();
}

class _AdminVendingMachinePageState extends State<AdminVendingMachinePage> {
  // Exemplo de lista de vending machines
  final List<Map<String, dynamic>> vendingMachines = [
    {
      'name': 'Pinho’s Vending Machine',
      'owner': 'Pinho',
      'additionalInfo': 'Essa máquina vive dando problema, parece as vending machines do IBMEC.',
    },
    {
      'name': 'Vending Machine 2',
      'owner': 'Owner 2',
      'additionalInfo': 'Informações adicionais da máquina 2.',
    },
    // Adicione mais máquinas conforme necessário
  ];

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
          'Vending Machines',
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
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemCount: vendingMachines.length,
        itemBuilder: (context, index) {
          final machine = vendingMachines[index];
          return GestureDetector(
            onTap: () {
              // Navegar para a página de detalhes da vending machine
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminVendingMachineDetailPage(
                    vendingMachineData: machine,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  // Imagem ou placeholder
                  Container(
                    width: 90,
                    height: 100,
                    color: Color(0xFFEEF3FC),
                    child: Icon(
                      Icons.local_drink,
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
                            // Informações da máquina
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  machine['name'] as String,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                    fontFamily: 'Roboto-SemiBold',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Owner: ${machine['owner']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF80869A),
                                    fontFamily: 'Roboto-Regular',
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Clique para ver detalhes',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF80869A),
                                    fontFamily: 'Roboto-Regular',
                                  ),
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
