import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/info/card_buy_info_request_model.dart';
import '../../model/info/card_buy_info_response_model.dart';
import '../card_buy_service.dart';

Future<CardBuyInfoResponseModel> cardBuyInfoService(
    Dio dio,
    CardBuyInfoRequestModel model,
    String localeName,
    ) async {
  final logger = CardBuyService.logger;
  const message = 'cardBuyInfoPayment';

  try {
    final response = await dio.post(
      '$walletApi/trading/buy/info',
      data: model.toJson(),
    );
    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);
      validateRejectResponse(responseData, localeName);

      return CardBuyInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
