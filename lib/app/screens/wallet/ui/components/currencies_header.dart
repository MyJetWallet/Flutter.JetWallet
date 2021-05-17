import 'package:flutter/material.dart';

class CurrenciesHeader extends StatelessWidget {
  const CurrenciesHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Currencies',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
