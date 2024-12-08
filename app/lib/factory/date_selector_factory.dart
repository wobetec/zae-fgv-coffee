// lib/factory/date_selector_factory.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'date_selector.dart';
import 'mobile_date_selector.dart';
import 'web_date_selector.dart';

class DateSelectorFactory {
  static DateSelector getDateSelector() {
    if (kIsWeb) {
      return WebDateSelector();
    } else if (Platform.isAndroid || Platform.isIOS) {
      return MobileDateSelector();
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
