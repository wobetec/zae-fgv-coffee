// lib/pages/reports_page.dart

import 'package:flutter/material.dart';
import 'constants.dart'; // Importar o arquivo de constantes

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  // Map to keep track of selected reports using formatted date strings as keys
  Map<String, bool> _selectedReports = {};

  @override
  Widget build(BuildContext context) {
    // Generate a list of the last 7 dates without time
    final List<DateTime> lastSevenDays = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: index));
      // Normalize the date to midnight to ensure consistent comparison
      return DateTime(date.year, date.month, date.day);
    });

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
          // Instructional text below the AppBar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select days to include in the report.',
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontFamily: 'Roboto-SemiBold',
              ),
            ),
          ),
          // List of reports
          Expanded(
            child: ListView.builder(
              itemCount: lastSevenDays.length,
              itemBuilder: (context, index) {
                final day = lastSevenDays[index];
                final formattedDate = _formatDate(day);

                final isSelected = _selectedReports[formattedDate] ?? false;

                return ReportListItem(
                  date: day,
                  formattedDate: formattedDate,
                  isSelected: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedReports[formattedDate] = value ?? false;
                    });
                  },
                );
              },
            ),
          ),
          // "Generate Report" Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GenerateReportButton(
              onPressed: () {
                // Get the list of selected dates
                final selectedDates = _selectedReports.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();

                if (selectedDates.isEmpty) {
                  // Show a message if no dates are selected
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('No Dates Selected'),
                      content:
                          Text('Please select at least one day to generate a report.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Simulate report generation and show confirmation
                  print('Generating report for dates: $selectedDates');

                  // Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Report Generated'),
                      content: Text(
                          'The report for the following dates has been generated:\n${selectedDates.join(', ')}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );

                  // Clear the selections
                  setState(() {
                    _selectedReports.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format the date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// Updated ReportListItem to include a Checkbox
class ReportListItem extends StatelessWidget {
  final DateTime date;
  final String formattedDate;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const ReportListItem({
    Key? key,
    required this.date,
    required this.formattedDate,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isSelected,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
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
      onTap: () {
        // Toggle selection when the list item is tapped
        onChanged(!isSelected);
      },
    );
  }
}

// GenerateReportButton remains the same
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
          color: Colors.white, // Changed text color to white for better contrast
          fontFamily: 'Roboto-Medium',
        ),
      ),
    );
  }
}
