import 'auth.dart';
import 'dart:convert';

import 'endpoints/endpoint_vending_machine.dart';

class VendingMachine {
  EndPointVendingMachine? _endPointVendingMachine;
  Auth _auth = Auth();

  VendingMachine._privateConstructor();

  static final VendingMachine _instance = VendingMachine._privateConstructor();

  factory VendingMachine() {
    return _instance;
  }

  initialize(EndPointVendingMachine? endPointVendingMachine, {bool force = false}) {
    if (_endPointVendingMachine == null || force) {
      _endPointVendingMachine = endPointVendingMachine;
    } else {
      _endPointVendingMachine = EndPointVendingMachine();
    }
  }

  Future<dynamic> getVendingMachines() async {
    if (!_auth.hasToken()) {
      throw Exception('No token');
    }
    return await _endPointVendingMachine!.getVendingMachines(_auth.getToken()!)
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