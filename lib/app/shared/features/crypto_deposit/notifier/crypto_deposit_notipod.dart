import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'crypto_deposit_notifier.dart';
import 'crypto_deposit_state.dart';

final cryptoDepositNotipod = StateNotifierProvider.autoDispose
    .family<CryptoDepositNotifier, CryptoDepositState, String>(
  (ref, assetSymbol) {
    return CryptoDepositNotifier(
      read: ref.read,
      assetSymbol: assetSymbol,
    );
  },
);
