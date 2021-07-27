import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'convert_notifier.dart';
import 'convert_state.dart';

final convertNotipod =
    StateNotifierProvider<ConvertNotifier, ConvertState>((ref) {
  return ConvertNotifier(ref.read);
});
