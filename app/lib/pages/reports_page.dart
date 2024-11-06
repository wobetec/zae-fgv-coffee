// lib/pages/reports_page.dart

import 'package:flutter/material.dart';
import 'constants.dart'; // Importar o arquivo de constantes

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: appBarTextStyle,
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Texto instrutivo abaixo do AppBar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select a day to generate the report.',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontFamily: 'Roboto-SemiBold',
              ),
            ),
          ),
          // Lista de relatórios
          Expanded(
            child: ListView.builder(
              itemCount: 7, // Exemplo para os últimos 7 dias
              itemBuilder: (context, index) {
                final day = DateTime.now().subtract(Duration(days: index));
                return ReportListItem(
                  date: day,
                  onTap: () {
                    // Lógica ao selecionar um relatório
                    // Exemplo: navegar para uma página de detalhes do relatório
                  },
                );
              },
            ),
          ),
          // Botão "Generate Report"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GenerateReportButton(
              onPressed: () {
                // Simula a geração do relatório e imprime a mensagem no terminal
                print('O relatório foi gerado');

                // Exibe uma mensagem de confirmação ao usuário
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Relatório Gerado'),
                    content: Text('O relatório foi gerado com sucesso.'),
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
        ],
      ),
    );
  }
}

// Componente para cada item da lista de relatórios
class ReportListItem extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const ReportListItem({Key? key, required this.date, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = '${date.day}/${date.month}/${date.year}';
    return ListTile(
      leading: Icon(Icons.insert_drive_file, color: primaryColor),
      title: Text(
        'Report for $formattedDate',
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontFamily: 'Roboto-SemiBold',
        ),
      ),
      subtitle: Text(
        'Generated report',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF80869A),
          fontFamily: 'Roboto-Regular',
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
      onTap: onTap,
    );
  }
}

// Componente para o botão "Generate Report"
class GenerateReportButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateReportButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
      ),
      onPressed: onPressed,
      child: Text(
        'Generate Report',
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontFamily: 'Roboto-Medium',
        ),
      ),
    );
  }
}
