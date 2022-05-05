import 'package:dio/dio.dart';

import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
import '../../../shared/helpers/handle_api_responses.dart';
import '../market_info_service.dart';
import '../model/market_info_request_model.dart';
import '../model/market_info_response_model.dart';

Future<MarketInfoResponseModel> marketInfoService(
  Dio dio,
  MarketInfoRequestModel model,
) async {
  final logger = MarketInfoService.logger;
  const message = 'marketInfoService';

  try {
    final response = await dio.post(
      '$walletApi/market/info',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return MarketInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
