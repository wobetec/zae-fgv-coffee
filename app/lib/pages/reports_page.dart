// lib/pages/reports_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/api/simple_report.dart';
import 'package:flutter_html/flutter_html.dart';
import 'constants.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _generateReport() async {
    if (_selectedDate == null) {
      _showErrorDialog('No Date Selected', 'Please select a day to generate a report.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    try {
      final reportData = await SimpleReport.getSimpleReport(dateStr);
      final content = reportData["content"] ?? "<p>No content</p>";

      setState(() {
        _isLoading = false;
      });

      _showLargeDialog(content, dateStr);

    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorDialog('Error', 'Failed to generate the report. Please try again.');
    }
  }

  void _showLargeDialog(String content, String dateStr) {
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          // Ajuste o tamanho conforme necessário. Aqui usamos 80% da largura e altura da tela.
          width: screenSize.width * 0.8,
          height: screenSize.height * 0.8,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report Generated',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('Report generated for: $dateStr'),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: content,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedDate = null;
                    });
                  },
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedDateText = 'No date selected';
    if (_selectedDate != null) {
      selectedDateText = 'Selected date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}';
    }

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
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select a day to generate a report.',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontFamily: 'Roboto-SemiBold',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              selectedDateText,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
              ),
              onPressed: () => _selectDate(context),
              icon: Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Roboto-Medium',
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                    ),
                    onPressed: _generateReport,
                    child: Text(
                      'Generate Report',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Roboto-Medium',
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
