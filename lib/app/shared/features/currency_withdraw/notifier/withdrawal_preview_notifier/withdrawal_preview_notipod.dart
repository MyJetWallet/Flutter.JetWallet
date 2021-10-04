import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/withdrawal_model.dart';
import 'withdrawal_preview_notifier.dart';
import 'withdrawal_preview_state.dart';

final withdrawalPreviewNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalPreviewNotifier, WithdrawalPreviewState, WithdrawalModel>(
  (ref, withdrawal) {
    return WithdrawalPreviewNotifier(ref.read, withdrawal);
  },
);
