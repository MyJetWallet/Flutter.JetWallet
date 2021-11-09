import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'enter_phone_notifier.dart';
import 'enter_phone_state.dart';

final enterPhoneNotipod = StateNotifierProvider.autoDispose<EnterPhoneNotifier,
    EnterPhoneState>(
  (ref) {
    return EnterPhoneNotifier();
  },
  name: 'enterPhoneNotipod',
);
