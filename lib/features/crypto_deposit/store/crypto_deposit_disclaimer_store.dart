import 'package:jetwallet/core/services/local_storage_service.dart';

enum CryptoDepositDisclaimer {
  accepted,
  notAccepted,
}

Future<CryptoDepositDisclaimer> getcryptoDepositDisclaimer(
  String assetSymbol,
) async {
  final storageService = sLocalStorageService;

  final disclaimer = await storageService.getValue(assetSymbol);

  return disclaimer == null ? CryptoDepositDisclaimer.notAccepted : CryptoDepositDisclaimer.accepted;
}
