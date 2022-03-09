import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/chart_input.dart';
import 'chart_notifier.dart';
import 'chart_state.dart';

final chartNotipod = StateNotifierProvider.autoDispose
    .family<ChartNotifier, ChartState, ChartInput>(
  (ref, chartInput) {
    return ChartNotifier(
      read: ref.read,
      chartInput: chartInput,
    );
  },
);
