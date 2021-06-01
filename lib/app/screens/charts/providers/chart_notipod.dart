import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service_providers.dart';
import '../notifiers/chart_notifier.dart';
import '../notifiers/state/chart_state.dart';

final chartNotipod =
    StateNotifierProvider.autoDispose<ChartNotifier, ChartState>(
  (ref) {
    final chartService = ref.watch(chartServicePod);

    return ChartNotifier(
      chartService: chartService,
    );
  },
);
