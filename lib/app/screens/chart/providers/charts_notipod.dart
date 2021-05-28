import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service_providers.dart';
import '../notifiers/chart_notifier.dart';
import '../notifiers/state/charts_state.dart';

final chartNotipod = StateNotifierProvider<ChartNotifier, ChartsState>(
      (ref) {
    final chartsService = ref.watch(chartsServicePod);

    return ChartNotifier(
      chartsService: chartsService,
    );
  },
);
