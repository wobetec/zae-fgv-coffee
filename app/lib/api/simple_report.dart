import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_simple_report.dart';


class SimpleReport {
  EndPointSimpleReport? _endPointSimpleReport;
  Auth _auth = Auth();

  SimpleReport._privateConstructor();

  static final SimpleReport _instance = SimpleReport._privateConstructor();

  factory SimpleReport() {
    return _instance;
  }

  initialize(EndPointSimpleReport? endPointSimpleReport, {bool force = false}) {
    if (_endPointSimpleReport == null || force) {
      _endPointSimpleReport = endPointSimpleReport;
    } else {
      _endPointSimpleReport = EndPointSimpleReport();
    }
  }

  Future<dynamic> getSimpleReport(String date) async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointSimpleReport!.getSimpleReport(_auth.getToken()!, date)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get SimpleReports');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get SimpleReports');
      });
    
  }
}