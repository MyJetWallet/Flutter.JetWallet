import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../helper/calculate_total_balance.dart';
import '../../model/currency_model.dart';

class WalletBalance extends HookWidget {
  const WalletBalance(this.currencies);

  final List<CurrencyModel> currencies;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.balance,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        Text(
          'USD ${calculateTotalBalance(2, currencies)}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
