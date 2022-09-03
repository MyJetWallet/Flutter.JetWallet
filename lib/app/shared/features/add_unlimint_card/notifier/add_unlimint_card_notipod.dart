import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'add_unlimint_card_notifier.dart';
import 'add_unlimint_card_state.dart';

final addUnlimintCardNotipod = StateNotifierProvider.autoDispose<
    AddUnlimintCardNotifier, AddUnlimintCardState>(
  (ref) {
    return AddUnlimintCardNotifier(ref.read);
  },
  name: 'addUnlimintCardNotipod',
);
