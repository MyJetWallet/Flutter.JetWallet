import 'package:charts/entity/k_line_entity.dart';
import 'package:charts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/loader.dart';
import '../../providers/charts_init_fpod.dart';
import '../../providers/charts_notipod.dart';

class ChartView extends HookWidget {
  const ChartView(this.instrumentId);

  final String instrumentId;

  @override
  Widget build(BuildContext context) {
    final initCharts = useProvider(chartsInitFpod(instrumentId));
    final chartsNotifier = useProvider(chartNotipod.notifier);
    final chartsState = useProvider(chartNotipod);

    return initCharts.when(
      data: (data) {
        return Chart(
            onResolutionChanged: (resolution) {
              chartsNotifier.getCandles(resolution, instrumentId);
            },
            candles: chartsState.candles
                .map((e) => KLineEntity.fromJson(e.toJson()))
                .toList());
      },
      loading: () {
        return Loader();
      },
      error: (_, __) {
        return const Text('Error');
      },
    );
  }
}
