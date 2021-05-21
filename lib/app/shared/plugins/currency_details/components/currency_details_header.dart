import 'package:flutter/material.dart';

import '../../../../screens/wallet/models/asset_with_balance_model.dart';

class CurrencyDetailsHeader extends StatelessWidget {
  const CurrencyDetailsHeader({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final AssetWithBalanceModel currency;

  @override
  Widget build(BuildContext context) {
    return Text(
      currency.description,
      style: const TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
