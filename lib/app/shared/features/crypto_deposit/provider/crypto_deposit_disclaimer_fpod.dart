import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';

final cryptoDepositDisclaimerFpod = FutureProvider.autoDispose
    .family<CryptoDepositDisclaimer, String>((ref, assetSymbol) async {
  final storageService = ref.watch(localStorageServicePod);

  final disclaimer = await storageService.getString(assetSymbol);

  if (disclaimer == null) {
    return CryptoDepositDisclaimer.notAccepted;
  } else {
    return CryptoDepositDisclaimer.accepted;
  }
});

enum CryptoDepositDisclaimer {
  accepted,
  notAccepted,
}
