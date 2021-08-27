import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';

final depositDisclaimerFpod = FutureProvider.autoDispose
    .family<DepositDisclaimer, String>((ref, assetSymbol) async {
  final storageService = ref.watch(localStorageServicePod);

  final disclaimer = await storageService.getString(assetSymbol);

  if (disclaimer == null) {
    return DepositDisclaimer.notAccepted;
  } else {
    return DepositDisclaimer.accepted;
  }
});

enum DepositDisclaimer {
  accepted,
  notAccepted,
}
