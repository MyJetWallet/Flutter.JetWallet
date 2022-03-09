import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/currency_model.dart';
import 'crypto_deposit_notifier.dart';
import 'crypto_deposit_state.dart';

final cryptoDepositNotipod = StateNotifierProvider.autoDispose
    .family<CryptoDepositNotifier, CryptoDepositState, CurrencyModel>(
  (ref, currency) {
    return CryptoDepositNotifier(
      read: ref.read,
      currency: currency,
    );
  },
);
