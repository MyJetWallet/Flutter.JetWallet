import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'send_by_phone_preview_notifier.dart';
import 'send_by_phone_preview_state.dart';

final sendByPhonePreviewNotipod =
    StateNotifierProvider<SendByPhonePreviewNotifier, SendByPhonePreviewState>(
  (ref) {
    return SendByPhonePreviewNotifier();
  },
  name: 'sendByPhonePreviewNotipod',
);
