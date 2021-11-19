import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_sell_input.dart';
import 'preview_sell_notifier.dart';
import 'preview_sell_state.dart';

final previewSellNotipod = StateNotifierProvider.family
    .autoDispose<PreviewSellNotifier, PreviewSellState, PreviewSellInput>(
  (ref, input) {
    return PreviewSellNotifier(input, ref.read);
  },
);
