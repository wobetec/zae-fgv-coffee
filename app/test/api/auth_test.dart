import "package:namer_app/api/auth.dart";
import "package:namer_app/api/endpoints/endpoint_auth.dart";
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';
import 'auth_test.mocks.dart';


@GenerateMocks([EndPointAuth])
void main(){
  Auth auth = Auth();

  // User
  group("Test login", (){
    test("Login with correct username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.login("esdras", "esdras")).thenAnswer((_) async => Response('{"token": "123"}', 200));
      auth.initialize(endPointAuth, force: true);
      await auth.login("esdras", "esdras", UserType.user);
      expect(auth.hasToken(), true);
    });

    test("Login with incorrect username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.login("esdras", "esdras")).thenAnswer((_) async => Response('{"error": "Invalid username or password"}', 400));
      auth.initialize(endPointAuth, force: true);

      expect(() async => await auth.login("esdras", "esdras", UserType.user), throwsException);
    });
  });

  group("Test logout", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.logout("123", "123")).thenAnswer((_) async => Response('{"message": "Logout successful"}', 200));
      auth.initialize(endPointAuth, force: true);

      // login
      auth.setToken("123");
      auth.setUserType(UserType.user);

      //logout
      await auth.logout("123");
      expect(auth.hasToken(), false);
    });

    test("without token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      auth.initialize(endPointAuth, force: true);
      expect(() async => await auth.logout("123"), throwsException);
    });
  });

  group("Test signup", (){
    test("with valid username, email and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.signup("esdras", "esdras", "esdras")).thenAnswer((_) async => Response('{"token": "123"}', 201));
      auth.initialize(endPointAuth, force: true);

      await auth.signup("esdras", "esdras", "esdras");
      expect(auth.hasToken(), true);
    });
  
    test("with invalid username, email and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.signup("esdras", "esdras", "esdras")).thenAnswer((_) async => Response('{"error": "Invalid username, email or password"}', 400));
      auth.initialize(endPointAuth, force: true);

      expect(() async => await auth.signup("esdras", "esdras", "esdras"), throwsException);
    });
  });

  group("Test test_token", (){
    test("with token", () async {
      auth.setToken("123");

      expect(auth.hasToken(), true);
    });
  });

  // Support user
  group("Test support login", (){
    test("Login with correct username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportLogin("esdras", "esdras")).thenAnswer((_) async => Response('{"token": "123"}', 200));
      auth.initialize(endPointAuth, force: true);

      await auth.login("esdras", "esdras", UserType.support);
      expect(auth.hasToken(), true);
    });

    test("Login with incorrect username and password", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportLogin("esdras", "esdras")).thenAnswer((_) async => Response('{"error": "Invalid username or password"}', 400));
      auth.initialize(endPointAuth, force: true);

      expect(() async => await auth.login("esdras", "esdras", UserType.support), throwsException);
    });
  });

  group("Test support logout", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportLogout("123", "123")).thenAnswer((_) async => Response('{"message": "Logout successful"}', 200));
      auth.initialize(endPointAuth, force: true);

      // login
      auth.setToken("123");
      auth.setUserType(UserType.support);

      //logout
      await auth.logout("123");
      expect(auth.hasToken(), false);
    });

    test("without token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      auth.initialize(endPointAuth, force: true);
      expect(() async => await auth.logout("123"), throwsException);
    });
  });

  group("Test check login status", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.testToken("123")).thenAnswer((_) async => Response('{"message": "Token is valid"}', 200));
      auth.initialize(endPointAuth, force: true);

      // login
      auth.setToken("123");
      auth.setUserType(UserType.user);

      expect(auth.hasToken(), true);
      expect(await auth.checkToken(), true);
    });
  });

  group("Test check support login status", (){
    test("with token", () async {
      EndPointAuth endPointAuth = MockEndPointAuth();
      when(endPointAuth.supportTestToken("123")).thenAnswer((_) async => Response('{"message": "Token is valid"}', 200));
      auth.initialize(endPointAuth, force: true);

      // login
      auth.setToken("123");
      auth.setUserType(UserType.support);
      expect(auth.hasToken(), true);

      // check token
      expect(await auth.checkToken(), true);
    });
  });
}
