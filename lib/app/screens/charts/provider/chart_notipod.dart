import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/service_providers.dart';
import '../notifier/chart_notifier.dart';
import '../notifier/chart_state.dart';

final chartNotipod =
    StateNotifierProvider.autoDispose<ChartNotifier, ChartState>(
  (ref) {
    final chartService = ref.watch(chartServicePod);

    return ChartNotifier(
      chartService: chartService,
    );
  },
);
