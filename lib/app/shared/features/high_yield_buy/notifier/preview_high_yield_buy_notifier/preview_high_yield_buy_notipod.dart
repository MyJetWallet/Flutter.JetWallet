import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_high_yield_buy_input.dart';
import 'preview_high_yield_buy_notifier.dart';
import 'preview_high_yield_buy_state.dart';

final previewHighYieldBuyNotipod = StateNotifierProvider.family.autoDispose<
    PreviewHighYieldBuyNotifier,
    PreviewHighYieldBuyState,
    PreviewHighYieldBuyInput>(
  (ref, input) {
    return PreviewHighYieldBuyNotifier(input, ref.read);
  },
);
