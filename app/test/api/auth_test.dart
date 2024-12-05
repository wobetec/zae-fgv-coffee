import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'auth_test.mocks.dart';


@GenerateMocks([EndPointAuth])
void main(){
  // User
  group("Test login", (){
    test("Login with correct username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.login("esdras", "esdras")).thenAnswer((_) async => Response('{"token": "123"}', 200));
      Auth.initialize(endPointAuth, force: true);

      await Auth.login("esdras", "esdras", UserType.user);
      expect(Auth.hasToken(), true);
    });

    test("Login with incorrect username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.login("esdras", "esdras")).thenAnswer((_) async => Response('{"error": "Invalid username or password"}', 400));
      Auth.initialize(endPointAuth, force: true);

      expect(() async => await Auth.login("esdras", "esdras", UserType.user), throwsException);
    });
  });

  group("Test logout", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.logout("123")).thenAnswer((_) async => Response('{"message": "Logout successful"}', 200));
      Auth.initialize(endPointAuth, force: true);

      // login
      Auth.setToken("123");
      Auth.setUserType(UserType.user);

      //logout
      await Auth.logout();
      expect(Auth.hasToken(), false);
    });

    test("without token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      Auth.initialize(endPointAuth, force: true);
      expect(() async => await Auth.logout(), throwsException);
    });
  });

  group("Test signup", (){
    test("with valid username, email and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.signup("esdras", "esdras", "esdras")).thenAnswer((_) async => Response('{"token": "123"}', 201));
      Auth.initialize(endPointAuth, force: true);

      await Auth.signup("esdras", "esdras", "esdras");
      expect(Auth.hasToken(), true);
    });
  
    test("with invalid username, email and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.signup("esdras", "esdras", "esdras")).thenAnswer((_) async => Response('{"error": "Invalid username, email or password"}', 400));
      Auth.initialize(endPointAuth, force: true);

      expect(() async => await Auth.signup("esdras", "esdras", "esdras"), throwsException);
    });
  });

  group("Test test_token", (){
    test("with token", () async {
      Auth.setToken("123");

      expect(Auth.hasToken(), true);
    });
  });

  // Support user
  group("Test support login", (){
    test("Login with correct username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportLogin("esdras", "esdras")).thenAnswer((_) async => Response('{"token": "123"}', 200));
      Auth.initialize(endPointAuth, force: true);

      await Auth.login("esdras", "esdras", UserType.support);
      expect(Auth.hasToken(), true);
    });

    test("Login with incorrect username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportLogin("esdras", "esdras")).thenAnswer((_) async => Response('{"error": "Invalid username or password"}', 400));
      Auth.initialize(endPointAuth, force: true);

      expect(() async => await Auth.login("esdras", "esdras", UserType.support), throwsException);
    });
  });

  group("Test support logout", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportLogout("123")).thenAnswer((_) async => Response('{"message": "Logout successful"}', 200));
      Auth.initialize(endPointAuth, force: true);

      // login
      Auth.setToken("123");
      Auth.setUserType(UserType.support);

      //logout
      await Auth.logout();
      expect(Auth.hasToken(), false);
    });

    test("without token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      Auth.initialize(endPointAuth, force: true);
      expect(() async => await Auth.logout(), throwsException);
    });
  });

  group("Test check login status", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.testToken("123")).thenAnswer((_) async => Response('{"message": "Token is valid"}', 200));
      Auth.initialize(endPointAuth, force: true);

      // login
      Auth.setToken("123");
      Auth.setUserType(UserType.user);

      expect(Auth.hasToken(), true);
      expect(await Auth.checkToken(), true);
    });
  });

  group("Test check support login status", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportTestToken("123")).thenAnswer((_) async => Response('{"message": "Token is valid"}', 200));
      Auth.initialize(endPointAuth, force: true);

      // login
      Auth.setToken("123");
      Auth.setUserType(UserType.support);
      expect(Auth.hasToken(), true);

      // check token
      expect(await Auth.checkToken(), true);
    });
  });
}
