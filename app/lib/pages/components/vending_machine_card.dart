// lib/components/vending_machine_card.dart

import 'package:flutter/material.dart';

class VendingMachineCard extends StatelessWidget {
  final String name;
  final String floor;
  final VoidCallback onTap;

  const VendingMachineCard({
    Key? key,
    required this.name,
    required this.floor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.local_drink, color: Colors.orange),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto-SemiBold',
          ),
        ),
        subtitle: Text(
          floor,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
