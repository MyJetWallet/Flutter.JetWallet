import 'package:flutter/material.dart';

import '../../../models/currency_model.dart';

class CurrencyDetailsHeader extends StatelessWidget {
  const CurrencyDetailsHeader({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Text(
      currency.name,
      style: const TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
