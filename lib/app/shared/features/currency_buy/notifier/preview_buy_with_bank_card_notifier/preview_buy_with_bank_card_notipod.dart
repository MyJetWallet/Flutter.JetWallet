import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_buy_with_bank_card_input.dart';
import 'preview_buy_with_bank_card_notifier.dart';
import 'preview_buy_with_bank_card_state.dart';

final previewBuyWithBankCardNotipod = StateNotifierProvider.family.autoDispose<
    PreviewBuyWithBankCardNotifier,
    PreviewBuyWithBankCardState,
    PreviewBuyWithBankCardInput>(
  (ref, input) {
    return PreviewBuyWithBankCardNotifier(input, ref.read);
  },
);
