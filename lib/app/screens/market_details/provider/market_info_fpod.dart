import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../service/services/wallet/model/market_info/market_info_request_model.dart';
import '../../../../service/services/wallet/model/market_info/market_info_response_model.dart';
import '../../../../shared/providers/service_providers.dart';

final marketInfoFpod =
    FutureProvider.family<MarketInfoResponseModel, MarketInfoRequestModel>(
        (ref, model) {
  final walletService = ref.watch(walletServicePod);

  return walletService.marketInfo(model);
});
