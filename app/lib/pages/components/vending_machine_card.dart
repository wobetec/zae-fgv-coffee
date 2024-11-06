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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          leading: Icon(
            Icons.local_drink,
            size: 50,
            color: Colors.orange,
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF232323),
              fontFamily: 'Roboto-SemiBold',
            ),
          ),
          subtitle: Text(
            floor,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF80869A),
              fontFamily: 'Roboto-Regular',
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
