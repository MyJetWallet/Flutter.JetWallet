import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chart_notifier.dart';
import 'chart_state.dart';

final chartNotipod =
    StateNotifierProvider.autoDispose<ChartNotifier, ChartState>(
  (ref) {
    return ChartNotifier(
      read: ref.read,
    );
  },
);
