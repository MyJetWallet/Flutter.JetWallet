import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketHeaderStats extends StatelessWidget {
  const MarketHeaderStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketInfo = sSignalRModules.marketInfo;

    return SPaddingH24(
      child: SMarketHeader(
        title: intl.marketHeaderStats_market,
        percent: marketInfo.toString(),
        isPositive: marketInfo > Decimal.zero,
        subtitle:
            '${intl.marketHeaderStats_marketIs} ${(marketInfo > Decimal.zero) ? intl.marketHeaderStats_up : intl.marketHeaderStats_down}',
        showInfo: marketInfo != Decimal.zero,
        isLoader: false,
      ),
    );
  }
}

class MarketHeaderSkeletonStats extends StatelessWidget {
  const MarketHeaderSkeletonStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: SMarketHeader(
        title: intl.marketHeaderStats_market,
        percent: '',
        isPositive: false,
        subtitle: '',
        showInfo: false,
        isLoader: true,
      ),
    );
  }
}
