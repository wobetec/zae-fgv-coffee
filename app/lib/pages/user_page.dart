// lib/pages/user_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/user_info_card.dart';
import 'components/menu_option.dart';
import 'order_history_page.dart';
import 'constants.dart';

import 'package:namer_app/api/auth.dart';
import 'package:namer_app/fcm/fcm.dart';
import 'home_page.dart';


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

  
  void _showDialog(String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) {
                onOk();
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
    try {
      await Auth.logout(FCM.deviceId!);
    } catch (e) {
      _showDialog('Error', 'Failed to logout. Please try again.');
      return;
    } 

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
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
