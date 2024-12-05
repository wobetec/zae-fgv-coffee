import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";

import "package:namer_app/api/vending_machine.dart";
import "package:namer_app/api/endpoints/endpoint_vending_machine.dart";

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'vending_machine_test.mocks.dart';


@GenerateMocks([EndPointVendingMachine])
void main(){
  group("Test getVendingMachines", (){
    test("Get vending machines with correct token", () async {
      EndPointVendingMachine endPointVendingMachine = MockEndPointVendingMachine();
      when(endPointVendingMachine.getVendingMachines("123")).thenAnswer((_) async => Response('[]', 200));
      Auth.initialize(EndPointAuth(), force: true);
      Auth.setToken("123");
      VendingMachine.initialize(endPointVendingMachine, force: true);

      dynamic vending_machines = await VendingMachine.getVendingMachines();
      expect(vending_machines, []);
    });

    test("Get vending machines with no token", () async {
      EndPointVendingMachine endPointVendingMachine = MockEndPointVendingMachine();

      Auth.initialize(EndPointAuth(), force: true, resetToken: true);
      VendingMachine.initialize(endPointVendingMachine, force: true);

      expect(() async => await VendingMachine.getVendingMachines(), throwsException);
    });
  });
}