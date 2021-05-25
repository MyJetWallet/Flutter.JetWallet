import 'package:flutter/material.dart';

import '../../../../../screens/wallet/models/asset_with_balance_model.dart';

class ConvertDropdown extends StatelessWidget {
  const ConvertDropdown({
    Key? key,
    required this.value,
    required this.currencies,
    required this.onChanged,
  }) : super(key: key);

  final AssetWithBalanceModel value;
  final List<AssetWithBalanceModel> currencies;
  final Function(AssetWithBalanceModel?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AssetWithBalanceModel>(
      value: value,
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      iconEnabledColor: Colors.black,
      dropdownColor: Colors.white,
      items: [
        for (final i in currencies)
          DropdownMenuItem(
            value: i,
            child: Text(
              '${i.description} (${i.symbol})',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
