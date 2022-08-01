import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_buy_with_unlimint_input.dart';
import 'preview_buy_with_unlimint_notifier.dart';
import 'preview_buy_with_unlimint_state.dart';

final previewBuyWithUnlimintNotipod = StateNotifierProvider.family.autoDispose<
    PreviewBuyWithUnlimintNotifier,
    PreviewBuyWithUnlimintState,
    PreviewBuyWithUnlimintInput>(
  (ref, input) {
    return PreviewBuyWithUnlimintNotifier(input, ref.read);
  },
);
