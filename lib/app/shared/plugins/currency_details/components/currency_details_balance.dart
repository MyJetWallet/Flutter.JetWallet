import 'package:flutter/material.dart';

import '../../../models/currency_model.dart';

class CurrencyDetailsBalance extends StatelessWidget {
  const CurrencyDetailsBalance({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Balance',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
        const Spacer(),
        Text(
          '${currency.amount} ${currency.symbol}',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }
}
