import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_buy_with_circle_input.dart';
import 'preview_buy_with_circle_notifier.dart';
import 'preview_buy_with_circle_state.dart';

final previewBuyWithCircleNotipod = StateNotifierProvider.family.autoDispose<
    PreviewBuyWithCircleNotifier,
    PreviewBuyWithCircleState,
    PreviewBuyWithCircleInput>(
  (ref, input) {
    return PreviewBuyWithCircleNotifier(input, ref.read);
  },
);
