import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/high_yield_buy_input.dart';
import 'high_yield_buy_notifier.dart';
import 'high_yield_buy_state.dart';

final highYieldBuyNotipod = StateNotifierProvider.autoDispose
    .family<HighYieldBuyNotifier, HighYieldBuyState, HighYieldBuyInput>(
  (ref, input) {
    return HighYieldBuyNotifier(ref.read, input);
  },
);
