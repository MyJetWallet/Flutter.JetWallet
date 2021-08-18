import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/convert_preview_input.dart';
import 'convert_notifier.dart';
import 'convert_state.dart';

final convertNotipod = StateNotifierProvider.family
    .autoDispose<ConvertNotifier, ConvertState, ConvertPreviewInput>(
  (ref, input) {
    return ConvertNotifier(input, ref.read);
  },
);
