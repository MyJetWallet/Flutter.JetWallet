import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'enter_card_details_notifier.dart';
import 'enter_card_details_state.dart';

final enterCardDetailsNotipod = StateNotifierProvider.autoDispose<
    EnterCardDetailsNotifier, EnterCardDetailsState>(
  (ref) {
    return EnterCardDetailsNotifier(ref.read);
  },
  name: 'enterCardDetailsNotipod',
);
