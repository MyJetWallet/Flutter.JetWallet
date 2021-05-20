import 'package:flutter/material.dart';

import '../../../../../../shared/models/currency_model.dart';

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 35.0,
            width: 35.0,
            child: Image.network(currency.image),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            currency.name,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${currency.amount} ${currency.symbol}'),
              Text(
                '${currency.baseCurrencySymbol} ${currency.baseCurrencyAmount}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
