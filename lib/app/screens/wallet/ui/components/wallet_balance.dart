import 'package:flutter/material.dart';

class WalletBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'BALANCE',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          'USD 0',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
