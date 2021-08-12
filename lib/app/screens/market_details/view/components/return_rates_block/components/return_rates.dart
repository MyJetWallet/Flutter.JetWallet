import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../provider/return_rates_pod.dart';
import 'return_rate_item.dart';

class ReturnRates extends HookWidget {
  const ReturnRates({
    Key? key,
    required this.instrument,
  }) : super(key: key);

  final String instrument;

  @override
  Widget build(BuildContext context) {
    final returnRates = useProvider(returnRatesPod(instrument));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReturnRateItem(
          header: '1 day',
          value: returnRates.dayPrice,
        ),
        ReturnRateItem(
          header: '7 days',
          value: returnRates.weekPrice,
        ),
        ReturnRateItem(
          header: '1 month',
          value: returnRates.monthPrice,
        ),
        ReturnRateItem(
          header: '3 month',
          value: returnRates.threeMonthPrice,
        ),
      ],
    );
  }
}
