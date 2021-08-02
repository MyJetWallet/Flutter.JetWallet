import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../service/services/wallet/model/market_info/market_info_request_model.dart';
import '../../../../service/services/wallet/model/market_info/market_info_response_model.dart';
import '../../../../shared/providers/service_providers.dart';

final marketInfoFpod =
    FutureProvider.family<MarketInfoResponseModel, String>((ref, id) {
  final walletService = ref.watch(walletServicePod);
  final intl = ref.read(intlPod);

  return walletService.marketInfo(
    MarketInfoRequestModel(
      assetId: id,
      language: intl.localeName,
    ),
  );
});
