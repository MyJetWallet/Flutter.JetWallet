import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import 'send_by_phone_preview_notifier.dart';
import 'send_by_phone_preview_state.dart';

final sendByPhonePreviewNotipod = StateNotifierProvider.autoDispose
    .family<SendByPhonePreviewNotifier, SendByPhonePreviewState, CurrencyModel>(
  (ref, currency) {
    return SendByPhonePreviewNotifier(ref.read, currency);
  },
  name: 'sendByPhonePreviewNotipod',
);
