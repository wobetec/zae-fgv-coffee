// lib/pages/user_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/user_info_card.dart';
import 'components/menu_option.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'home_app_page.dart';
import 'my_favorite_page.dart';
import 'order_history_page.dart';
import 'login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = '';
  String email = '';

  int _currentIndex = 1; // Highlight the 'Profile' tab

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      email = prefs.getString('email') ?? 'email@example.com';
    });
  }

  // Function to handle sign out
  void _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigate to LoginPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void _onNavBarTap(int index) {
    if (index == 0) {
      // Navigate to HomeAppPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAppPage()),
      );
    }
    // If index is 1, we're already on the Profile page.
  }

  @override
  Widget build(BuildContext context) {
    // Define colors
    final primaryColor = Color(0xFFFF5722);
    final textColor = Color(0xFF232323);
    final backgroundColor = Color(0xFFFFFFFF);
    final cardColor = Color(0xFFE2E2E2);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: textColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        children: [
          // User Info Card
          UserInfoCard(
            username: username,
            email: email,
            textColor: textColor,
            cardColor: cardColor,
          ),
          // Menu Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Divider(color: cardColor),
                MenuOption(
                  icon: Icons.history,
                  title: 'Order History',
                  onTap: () {
                    // Navigate to OrderHistoryPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderHistoryPage()),
                    );
                  },
                ),
                Divider(color: cardColor),
                MenuOption(
                  icon: Icons.favorite,
                  title: 'My Favorites',
                  onTap: () {
                    // Navigate to MyFavoritePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyFavoritePage()),
                    );
                  },
                ),
                Divider(color: cardColor),
                MenuOption(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  onTap: _signOut,
                ),
                Divider(color: cardColor),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
