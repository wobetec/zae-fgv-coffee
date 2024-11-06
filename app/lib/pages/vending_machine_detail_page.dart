// lib/pages/admin_vending_machine_detail_page.dart

import 'package:flutter/material.dart';
import 'constants.dart'; // Importar as constantes
import 'components/labeled_info_section.dart'; // Importar o novo componente

class AdminVendingMachineDetailPage extends StatelessWidget {
  final Map<String, dynamic> vendingMachineData;

  const AdminVendingMachineDetailPage({
    Key? key,
    required this.vendingMachineData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String vendingMachineName = vendingMachineData['name'] ?? 'Vending Machine';
    final String ownerName = vendingMachineData['owner'] ?? 'Nome do Proprietário';
    final String additionalInfo = vendingMachineData['additionalInfo'] ??
        'Informações adicionais sobre a vending machine.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          vendingMachineName,
          style: appBarTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            // Seção OWNER
            LabeledInfoSection(
              label: 'Owner',
              content: ownerName,
            ),
            // Seção ADDITIONAL INFORMATION
            LabeledInfoSection(
              label: 'Additional Information',
              content: additionalInfo,
            ),
            Spacer(),
            // Botão BLOCK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Simula o bloqueio da vending machine e imprime a mensagem
                  print('A vending machine $vendingMachineName foi bloqueada');
                  // Exibir uma mensagem de confirmação ao administrador
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Vending Machine Bloqueada'),
                      content: Text('A vending machine $vendingMachineName foi bloqueada com sucesso.'),
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
                  style: buttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
