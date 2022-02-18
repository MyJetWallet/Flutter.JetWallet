import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../provider/market_info_pod.dart';

class MarketHeaderStats extends HookWidget {
  const MarketHeaderStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketInfo = useProvider(marketInfoPod);

    return SPaddingH24(
      child: SMarketHeader(
        title: 'Market',
        percent: marketInfo.toString(),
        isPositive: marketInfo > Decimal.zero,
        subtitle: 'Market is ${(marketInfo > Decimal.zero) ? 'up' : 'down'}',
        showInfo: marketInfo != Decimal.zero,
      ),
    );
  }
}
