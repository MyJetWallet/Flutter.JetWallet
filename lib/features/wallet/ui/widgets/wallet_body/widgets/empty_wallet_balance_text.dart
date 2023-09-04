import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../utils/formatting/base/base_currencies_format.dart';

class EmptyWalletBalanceText extends StatelessWidget {
  const EmptyWalletBalanceText({
    super.key,
    required this.height,
    required this.baseline,
    required this.color,
  });

  final Color color;
  final double height;
  final double baseline;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;

    return SizedBox(
      height: height,
      child: Baseline(
        baseline: baseline,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          baseCurrenciesFormat(
            prefix: baseCurrency.prefix ?? '',
            text: '0',
            symbol: baseCurrency.symbol,
          ),
          style: sTextH0Style.copyWith(
            color: color,
          ),
        ),
      ),
    );
  }
}
