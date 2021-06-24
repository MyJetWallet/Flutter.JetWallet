import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/api_urls.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/asset_converter_map_model.dart';
import '../wallet_service.dart';

Future<AssetConverterMapModel> assetConverterMapService(
  Dio dio,
  String symbol,
) async {
  final logger = WalletService.logger;
  const message = 'assetConverterMapService';

  try {
    final response = await dio.get(
      '$walletApiBaseUrl/wallet/base-currency-converter-map/$symbol',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return AssetConverterMapModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
