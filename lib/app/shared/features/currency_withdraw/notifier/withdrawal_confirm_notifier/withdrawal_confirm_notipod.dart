import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/withdrawal_model.dart';
import 'withdrawal_confirm_notifier.dart';

final withdrawalConfirmNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalConfirmNotifier, void, WithdrawalModel>(
  (ref, withdrawal) {
    return WithdrawalConfirmNotifier(ref.read, withdrawal);
  },
);
