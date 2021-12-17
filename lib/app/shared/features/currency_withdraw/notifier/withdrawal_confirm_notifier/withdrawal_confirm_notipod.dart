import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/withdrawal_model.dart';
import 'withdrawal_confirm_notifier.dart';
import 'withdrawal_confirm_state.dart';

final withdrawalConfirmNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalConfirmNotifier, WithdrawalConfirmState, WithdrawalModel>(
  (ref, withdrawal) {
    return WithdrawalConfirmNotifier(ref.read, withdrawal);
  },
);
