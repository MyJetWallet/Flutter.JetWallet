import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/conversion_price_model/conversion_price_model.dart';
import '../wallet_service.dart';

Future<ConversionPriceModel> conversionPriceService(
  Dio dio,
  String baseAssetSymbol,
  String quotedAssetSymbol,
  String localeName,
) async {
  final logger = WalletService.logger;
  const message = 'conversionPriceService';

  try {
    final response = await dio.get(
      '$walletApi/wallet/conversion-price/$baseAssetSymbol/$quotedAssetSymbol',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return ConversionPriceModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
