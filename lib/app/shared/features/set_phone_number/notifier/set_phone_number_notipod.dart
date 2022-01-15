import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'set_phone_number_notifier.dart';
import 'set_phone_number_state.dart';

final setPhoneNumberNotipod = StateNotifierProvider.autoDispose<
    SetPhoneNumberNotifier, SetPhoneNumberState>(
  (ref) {
    return SetPhoneNumberNotifier(ref.read);
  },
  name: 'setPhoneNumberNotipod',
);
