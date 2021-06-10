import 'package:flutter/material.dart';

import '../../../../model/currency_model.dart';

const _temp = 'https://i.imgur.com/cvNa7tH.png';

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
            child: Image.network(_temp),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            currency.description,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${currency.assetBalance} ${currency.symbol}'),
              Text(
                currency.baseBalance == -1
                    ? 'unknown'
                    : 'USD ${currency.baseBalance}',
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
