import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/asset_tile/asset_tile.dart';
import '../../../../models/currency_model.dart';

class DepositCurrency extends StatelessWidget {
  const DepositCurrency({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: AssetTile(
        firstColumnSubheader: '${currency.currentPrice} /'
            ' ${currency.dayPercentChange} %',
        enableBorder: false,
        headerColor: Colors.black,
        currency: currency,
      ),
    );
  }
}
