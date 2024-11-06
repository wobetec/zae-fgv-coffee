// lib/components/user_info_card.dart

import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String username;
  final String email;
  final Color textColor;
  final Color cardColor;

  const UserInfoCard({
    Key? key,
    required this.username,
    required this.email,
    required this.textColor,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
