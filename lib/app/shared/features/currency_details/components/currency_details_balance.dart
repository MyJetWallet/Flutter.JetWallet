import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../screens/wallet/model/currency_model.dart';

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
        Text(
          'Balance',
          style: TextStyle(
            fontSize: 22.sp,
          ),
        ),
        const Spacer(),
        Text(
          '${currency.assetBalance} ${currency.symbol}',
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }
}
