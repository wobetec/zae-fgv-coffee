// lib/pages/components/user_info_card.dart

import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String username;
  final Color textColor;
  final Color cardColor;

  const UserInfoCard({
    Key? key,
    required this.username,
    required this.textColor,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: EdgeInsets.all(16.0),
      child: ListTile(
        leading: Icon(Icons.person, color: textColor, size: 50),
        title: Text(
          username,
          style: TextStyle(color: textColor, fontSize: 20),
        ),
      ),
    );
  }
}
