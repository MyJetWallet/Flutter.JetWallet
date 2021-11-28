import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'change_phone_notifier.dart';
import 'change_phone_state.dart';

final changePhoneNotipod = StateNotifierProvider<
    ChangePhoneNotifier, ChangePhoneState>(
      (ref) {
    return ChangePhoneNotifier(
      ref.read,
    );
  },
  name: 'changePhoneNotipod',
);
