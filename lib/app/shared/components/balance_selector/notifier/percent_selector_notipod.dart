import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/selected_percent.dart';
import 'percent_selector_notifier.dart';

final percentSelectorNotipod =
    StateNotifierProvider.autoDispose<PercentSelectorNotifier, SelectedPercent>(
  (ref) => PercentSelectorNotifier(),
);
