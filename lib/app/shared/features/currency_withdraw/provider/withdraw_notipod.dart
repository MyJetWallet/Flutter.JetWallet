import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../notifier/withdraw_notifier.dart';
import '../notifier/withdraw_state.dart';

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
