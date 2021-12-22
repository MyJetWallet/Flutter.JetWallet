import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../send_by_phone_permission_notifier/send_by_phone_permission_notipod.dart';
import 'send_by_phone_input_notifier.dart';
import 'send_by_phone_input_state.dart';

final sendByPhoneInputNotipod = StateNotifierProvider.autoDispose<
    SendByPhoneInputNotifier, SendByPhoneInputState>(
  (ref) {
    final permission = ref.watch(sendByPhonePermissionNotipod);

    return SendByPhoneInputNotifier(ref.read, permission);
  },
  name: 'sendByPhoneInputNotipod',
);
