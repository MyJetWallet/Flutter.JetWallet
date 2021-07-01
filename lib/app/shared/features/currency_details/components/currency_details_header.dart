import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../screens/wallet/model/currency_model.dart';

class CurrencyDetailsHeader extends StatelessWidget {
  const CurrencyDetailsHeader({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Text(
      currency.description,
      style: TextStyle(
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
