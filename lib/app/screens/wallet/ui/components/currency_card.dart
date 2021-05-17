import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    Key? key,
    required this.name,
    required this.symbol,
    required this.image,
    required this.amount,
    required this.baseCurrencySymbol,
    required this.baseCurrencyAmount,
  }) : super(key: key);

  final String name;
  final String symbol;
  final String image;
  final int amount;
  final String baseCurrencySymbol;
  final int baseCurrencyAmount;

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
            child: Image.network(image),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text('$amount $symbol'),
              Text(
                '$baseCurrencySymbol $baseCurrencyAmount',
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
