// lib/factory/date_selector.dart

import 'package:flutter/material.dart';

abstract class DateSelector {
  Future<DateTime?> selectDate(BuildContext context);
}
