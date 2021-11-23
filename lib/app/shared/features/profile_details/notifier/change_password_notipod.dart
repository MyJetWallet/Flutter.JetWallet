import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/change_password_pod.dart';
import 'change_password_notifier.dart';
import 'change_password_state.dart';

final changePasswordNotipod = StateNotifierProvider.autoDispose<
    ChangePasswordNotifier, ChangePasswordState>(
  (ref) {
    final changePasswordService = ref.watch(changePasswordPod);

    return ChangePasswordNotifier(
      changePasswordService: changePasswordService,
    );
  },
  name: 'changePasswordNotipod',
);
