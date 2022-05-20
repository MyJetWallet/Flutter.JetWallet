import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/return_to_wallet_input.dart';
import 'return_to_wallet_notifier.dart';
import 'return_to_wallet_state.dart';

final returnToWalletNotipod = StateNotifierProvider.autoDispose
    .family<ReturnToWalletNotifier, ReturnToWalletState, ReturnToWalletInput>(
  (ref, input) {
    return ReturnToWalletNotifier(ref.read, input);
  },
);
