import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'set_phone_number_notifier.dart';
import 'set_phone_number_state.dart';

final phoneNumberNotipod = StateNotifierProvider.autoDispose<
    PhoneNumberNotifier, PhoneNumberState>(
  (ref) {
    return PhoneNumberNotifier(ref.read);
  },
  name: 'setPhoneNumberNotipod',
);
