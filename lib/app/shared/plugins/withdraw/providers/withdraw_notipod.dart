import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service_providers.dart';
import '../notifiers/state/withdraw_state.dart';
import '../notifiers/withdraw_notifier.dart';

final withdrawNotipod =
    StateNotifierProvider.family<WithdrawNotifier, WithdrawState, String>(
  (ref, assetSymbol) {
    final blockchainService = ref.watch(blockchainServicePod);

    return WithdrawNotifier(
      blockchainService: blockchainService,
      assetSymbol: assetSymbol,
    );
  },
);
