// lib/factory/web_date_selector.dart

import 'package:flutter/material.dart';
import 'date_selector.dart';

class WebDateSelector implements DateSelector {
  @override
  Future<DateTime?> selectDate(BuildContext context) async {
    final TextEditingController _controller = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter a date (YYYY-MM-DD)'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'e.g., 2024-12-01'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              try {
                selectedDate = DateTime.parse(_controller.text);
                Navigator.pop(context);
              } catch (e) {
                Navigator.pop(context);
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );

    return selectedDate;
  }
}
