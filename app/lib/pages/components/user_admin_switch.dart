// lib/components/user_admin_switch.dart

import 'package:flutter/material.dart';
import '../constants.dart';

class UserAdminSwitch extends StatelessWidget {
  final bool isAdmin;
  final ValueChanged<bool> onToggle;

  const UserAdminSwitch({
    Key? key,
    required this.isAdmin,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Legend "User"
        Text(
          'User',
          style: TextStyle(
            fontSize: 16,
            color: !isAdmin ? primaryColor : textColor,
            fontFamily: 'Roboto-Regular',
          ),
        ),
        SizedBox(width: 8),
        // Switch
        Switch(
          value: isAdmin,
          onChanged: onToggle,
          activeColor: primaryColor,
          inactiveThumbColor: primaryColor,
          inactiveTrackColor: Colors.grey.shade300,
        ),
        SizedBox(width: 8),
        // Legend "Admin"
        Text(
          'Admin',
          style: TextStyle(
            fontSize: 16,
            color: isAdmin ? primaryColor : textColor,
            fontFamily: 'Roboto-Regular',
          ),
        ),
      ],
    );
  }
}
