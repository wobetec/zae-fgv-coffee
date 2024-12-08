// lib/factory/mobile_date_selector.dart

import 'package:flutter/material.dart';
import 'date_selector.dart';

class MobileDateSelector implements DateSelector {
  @override
  Future<DateTime?> selectDate(BuildContext context) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
  }
}
