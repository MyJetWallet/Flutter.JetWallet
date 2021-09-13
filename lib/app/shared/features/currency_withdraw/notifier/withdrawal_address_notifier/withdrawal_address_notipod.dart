import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/withdrawal_model.dart';
import 'withdrawal_address_notifier.dart';
import 'withdrawal_address_state.dart';

final withdrawalAddressNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalAddressNotifier, WithdrawalAddressState, WithdrawalModel>(
  (ref, withdrawal) {
    return WithdrawalAddressNotifier(ref.read, withdrawal);
  },
);
