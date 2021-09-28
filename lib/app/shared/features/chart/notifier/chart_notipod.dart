import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import 'chart_notifier.dart';
import 'chart_state.dart';

final chartNotipod =
    StateNotifierProvider.autoDispose<ChartNotifier, ChartState>(
  (ref) {
    final chartService = ref.watch(chartServicePod);
    final baseCurrency = ref.watch(baseCurrencyPod);

    return ChartNotifier(
      chartService: chartService,
      baseCurrencySymbol: baseCurrency.symbol,
    );
  },
);
