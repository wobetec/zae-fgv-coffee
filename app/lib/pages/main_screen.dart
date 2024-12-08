// lib/pages/main_screen.dart

import 'package:flutter/material.dart';
import 'home_app_page.dart';
import 'user_page.dart';
import 'my_favorite_page.dart';
import 'constants.dart';

import 'package:namer_app/api/auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Auth auth = Auth();
    bool isLogged = await auth.checkToken();
    if (!isLogged) {
      Navigator.pushReplacementNamed(context, '/');
    }
    setState(() {
      username = auth.getUsername()!;
    });
  }

  // List of pages to display
  late List<Widget> _pages;

  // List of titles for the AppBar
  late List<String> _titles;

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomeAppPage(username: username),
      MyFavoritePage(),
      UserPage(),
    ];

    _titles = [
      'Olá $username,\nO que você está procurando?',
      'My Favorites',
      'My Profile',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(
            color: textColor,
            fontSize: _currentIndex == 0 ? 20 : 18,
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        automaticallyImplyLeading: false, // Remove the back button
        toolbarHeight: _currentIndex == 0 ? 100 : kToolbarHeight,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
