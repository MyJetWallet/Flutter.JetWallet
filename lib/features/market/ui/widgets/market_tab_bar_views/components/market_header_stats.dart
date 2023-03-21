import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketHeaderStats extends StatelessObserverWidget {
  const MarketHeaderStats({
    super.key,
    this.activeFilters = 0,
    this.onFilterButtonTap,
    this.onSearchButtonTap,
  });

  final int activeFilters;
  final Function()? onFilterButtonTap;
  final Function()? onSearchButtonTap;

  @override
  Widget build(BuildContext context) {
    final marketInfo = sSignalRModules.marketInfo;

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 4,
      ),
      child: SMarketHeader(
        title: intl.marketHeaderStats_market,
        percent: marketInfo.toString(),
        isPositive: marketInfo > Decimal.zero,
        subtitle:
            '${intl.marketHeaderStats_marketIs} ${(marketInfo > Decimal.zero) ? intl.marketHeaderStats_up : intl.marketHeaderStats_down}',
        showInfo: marketInfo != Decimal.zero,
        isLoader: false,
        onFilterButtonTap: onFilterButtonTap,
        onSearchButtonTap: onSearchButtonTap,
        activeFilters: activeFilters,
      ),
    );
  }
}

class MarketHeaderSkeletonStats extends StatelessWidget {
  const MarketHeaderSkeletonStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 4,
      ),
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
