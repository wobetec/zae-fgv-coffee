import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/menu_option.dart';
import 'components/custom_bottom_nav_bar.dart';
import 'home_app_page.dart';
import 'my_favorite.dart'; // Importa a nova página

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = '';
  String email = '';

  int _currentIndex = 1; // Define como 1 para destacar o 'Profile'

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Função para carregar os dados do usuário do SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      email = prefs.getString('email') ?? 'email@example.com';
    });
  }

  // Função para lidar com o sign out
  void _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onNavBarTap(int index) {
    if (index == 0) {
      // Navegar para HomeAppPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAppPage()),
      );
    }
    // Se o índice for 1, já estamos na página de perfil.
  }

  @override
  Widget build(BuildContext context) {
    // Define as cores
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
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 64,
                  color: textColor,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontFamily: 'Roboto-SemiBold',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                    // Handle Order History tap
                  },
                ),
                Divider(color: cardColor),
                MenuOption(
                  icon: Icons.favorite,
                  title: 'My Favorite',
                  onTap: () {
                    // Navegar para a MyFavoritePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyFavoritePage()),
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
