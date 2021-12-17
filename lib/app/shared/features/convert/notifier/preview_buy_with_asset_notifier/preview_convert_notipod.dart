import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/preview_convert_input.dart';
import 'preview_convert_notifier.dart';
import 'preview_convert_state.dart';

final previewConvertNotipod = StateNotifierProvider.family.autoDispose<
    PreviewConvertNotifier, PreviewConvertState, PreviewConvertInput>(
  (ref, input) {
    return PreviewConvertNotifier(input, ref.read);
  },
);
