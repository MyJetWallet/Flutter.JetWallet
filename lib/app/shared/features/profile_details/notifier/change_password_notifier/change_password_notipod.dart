import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'change_password_notifier.dart';
import 'change_password_state.dart';

final changePasswordNotipod = StateNotifierProvider.autoDispose<
    ChangePasswordNotifier, ChangePasswordState>(
  (ref) {
    return ChangePasswordNotifier(
      read: ref.read,
    );
  },
  name: 'changePasswordNotipod',
);
