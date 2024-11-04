import 'package:flutter/material.dart';
import 'home_app_page.dart'; // Importe outras páginas conforme necessário

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFFF5722);
    final textColor = Color(0xFF232323);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Reports',
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
      body: Column(
        children: [
          // Texto abaixo do AppBar
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
          // Lista de dias (exemplo)
          Expanded(
            child: ListView.builder(
              itemCount: 7, // Por exemplo, últimos 7 dias
              itemBuilder: (context, index) {
                final day = DateTime.now().subtract(Duration(days: index));
                return ListTile(
                  leading: Icon(Icons.insert_drive_file, color: primaryColor),
                  title: Text(
                    'Report for ${day.day}/${day.month}/${day.year}',
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
                  onTap: () {
                    // Lógica ao selecionar um relatório
                  },
                );
              },
            ),
          ),
          // Botão "Generate Report"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
              ),
              onPressed: () {
                // Simula a geração do relatório e imprime a mensagem no terminal
                print('O relatório foi gerado');

                // Opcional: Exibir uma mensagem de confirmação ao usuário
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
              child: Text(
                'Generate Report',
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
