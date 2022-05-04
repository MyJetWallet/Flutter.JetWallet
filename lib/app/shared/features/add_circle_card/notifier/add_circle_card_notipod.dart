import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'add_circle_card_notifier.dart';
import 'add_circle_card_state.dart';

final addCircleCardNotipod = StateNotifierProvider.autoDispose<
    AddCircleCardNotifier, AddCircleCardState>(
  (ref) {
    return AddCircleCardNotifier(ref.read);
  },
  name: 'addCircleCardNotipod',
);
