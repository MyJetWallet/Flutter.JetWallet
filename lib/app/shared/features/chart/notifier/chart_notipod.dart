import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chart_notifier.dart';
import 'chart_state.dart';

final chartNotipod = StateNotifierProvider.autoDispose
    .family<ChartNotifier, ChartState, String?>(
  (ref, instrumentId) {
    return ChartNotifier(
      read: ref.read,
      instrumentId: instrumentId,
    );
  },
);
