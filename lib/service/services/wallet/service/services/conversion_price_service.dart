import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/conversion_price_model/conversion_price_model.dart';
import '../wallet_service.dart';

Future<ConversionPriceModel> conversionPriceService(
  Dio dio,
  String baseAssetSymbol,
  String quotedAssetSymbol,
) async {
  final logger = WalletService.logger;
  const message = 'conversionPriceService';

  try {
    final response = await dio.get(
      '$walletApi/wallet/conversion-price/$baseAssetSymbol/$quotedAssetSymbol',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

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
