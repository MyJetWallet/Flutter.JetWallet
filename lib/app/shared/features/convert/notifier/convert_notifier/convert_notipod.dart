import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../convert_input_notifier/convert_input_state.dart';
import 'convert_notifier.dart';
import 'convert_state.dart';

final convertNotipod = StateNotifierProvider.family
    .autoDispose<ConvertNotifier, ConvertState, ConvertInputState>(
        (ref, input) {
  return ConvertNotifier(input, ref.read);
});
