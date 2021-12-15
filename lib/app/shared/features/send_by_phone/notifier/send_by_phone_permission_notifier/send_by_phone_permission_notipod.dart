import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'send_by_phone_permission_notifier.dart';
import 'send_by_phone_permission_state.dart';

final sendByPhonePermissionNotipod = StateNotifierProvider<
    SendByPhonePermissionNotifier, SendByPhonePermissionState>(
  (ref) {
    return SendByPhonePermissionNotifier(ref.read);
  },
  name: 'sendByPhonePermissionNotipod',
);
