import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/loaders/loader.dart';
import '../../notifier/chart_notipod.dart';

class LoadingChartView extends HookWidget {
  const LoadingChartView({
    Key? key,
    this.walletCreationDate,
  }) : super(key: key);

  final String? walletCreationDate;

  @override
  Widget build(BuildContext context) {
    final chart = useProvider(chartNotipod);

    return SizedBox(
      height: 336.h,
      width: double.infinity,
      child: Stack(
        children: [
          Chart(
            onResolutionChanged: (_) {},
            onChartTypeChanged: (_) {},
            onCandleSelected: (_) {},
            candles: const [],
            candleResolution: chart.resolution,
            walletCreationDate: walletCreationDate,
          ),
          const Loader(),
        ],
      ),
    );
  }
}
