import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_vending_machine.dart';

class VendingMachine {
  static EndPointVendingMachine? _endPointVendingMachine;

  static initialize(EndPointVendingMachine? endPointVendingMachine, {bool force = false}) {
    if (_endPointVendingMachine == null || force) {
      _endPointVendingMachine = endPointVendingMachine;
    } else {
      _endPointVendingMachine = EndPointVendingMachine();
    }
  }

  static Future<dynamic> getVendingMachines() async {
    if (!Auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointVendingMachine!.getVendingMachines(Auth.getToken()!)
      .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Failed to get vending machines');
        }
        return jsonDecode(response.body);
      })
      .catchError((error) {
        throw Exception('Failed to get vending machines');
      });
  }
}