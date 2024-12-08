import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_simple_report.dart';

class SimpleReport {
  static EndPointSimpleReport? _endPointSimpleReport;

  static initialize(EndPointSimpleReport? endPointSimpleReport,
      {bool force = false}) {
    if (_endPointSimpleReport == null || force) {
      _endPointSimpleReport = endPointSimpleReport;
    } else {
      _endPointSimpleReport = EndPointSimpleReport();
    }
  }

  static Future<dynamic> getSimpleReport(String date) async {
    print(date);
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointSimpleReport!
        .getSimpleReport(Auth.getToken()!, date)
        .then((response) {
          print(response);
      if (response.statusCode != 200) {
        throw Exception('Failed to get SimpleReports');
      }
      return jsonDecode(response.body);
    }).catchError((error) {
      throw Exception('Failed to get SimpleReports');
    });
  }
}
