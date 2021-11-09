import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';

import 'send_preview_notifier.dart';
import 'send_preview_state.dart';

final sendPreviewNotipod = StateNotifierProvider.autoDispose
    .family<SendPreviewNotifier, SendPreviewState, WithdrawalModel>(
  (ref, withdrawal) {
    return SendPreviewNotifier(ref.read, withdrawal);
  },
);
