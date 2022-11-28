import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_info/market_info_response_model.dart';

Future<MarketInfoResponseModel?> getMarketInfo(String id) async {
  try {
    final response = await sNetwork.getWalletModule().postMarketInfo(
          MarketInfoRequestModel(
            assetId: id,
            language: intl.localeName,
          ),
        );

    return response.data;
  } catch (_) {
    return Future.value();
  }
}
