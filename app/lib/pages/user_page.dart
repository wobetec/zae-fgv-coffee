// lib/pages/user_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/user_info_card.dart';
import 'components/menu_option.dart';
import 'login_page.dart';
import 'order_history_page.dart';
import 'constants.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = '';

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

  @override
  Widget build(BuildContext context) {
    // Define colors
    final cardColor = Color(0xFFE2E2E2);

    return ListView(
      key: PageStorageKey('UserPage'),
      children: [
        // User Info Card
        UserInfoCard(
          username: username,
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
              // Removed 'My Favorites' MenuOption
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
    );
  }
}
