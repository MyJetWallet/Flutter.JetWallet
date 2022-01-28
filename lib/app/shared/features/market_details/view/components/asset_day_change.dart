import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../providers/base_currency_pod/base_currency_model.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../chart/notifier/chart_notipod.dart';
import '../../../chart/notifier/chart_state.dart';
import '../../helper/period_change.dart';

class AssetDayChange extends HookWidget {
  const AssetDayChange({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final chart = useProvider(chartNotipod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final periodChange = _periodChange(
      chart,
      baseCurrency,
    );
    final periodChangeColor =
        periodChange.contains('-') ? colors.red : colors.green;

    return Text(
      periodChange,
      style: sSubtitle3Style.copyWith(
        color: periodChangeColor,
      ),
    );
  }

  String _periodChange(
    ChartState chart,
    BaseCurrencyModel baseCurrency,
  ) {
    if (chart.selectedCandle != null) {
      return periodChange(
        chart: chart,
        selectedCandle: chart.selectedCandle,
        baseCurrency: baseCurrency,
      );
    } else {
      return periodChange(
        chart: chart,
        baseCurrency: baseCurrency,
      );
    }
  }
}
