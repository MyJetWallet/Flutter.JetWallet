import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/create/card_buy_create_request_model.dart';
import '../../model/create/card_buy_create_response_model.dart';
import '../card_buy_service.dart';

Future<CardBuyCreateResponseModel> cardBuyCreateService(
  Dio dio,
  CardBuyCreateRequestModel model,
  String localeName,
) async {
  final logger = CardBuyService.logger;
  const message = 'cardBuyCreatePayment';

  try {
    final response = await dio.post(
      '$walletApi/trading/buy/create',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return CardBuyCreateResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
