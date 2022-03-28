import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'action_search_notifier.dart';
import 'action_search_state.dart';

final actionSearchNotipod = StateNotifierProvider<
    ActionSearchNotifier, ActionSearchState>((ref) {

  return ActionSearchNotifier(
    read: ref.read,
  );
});
