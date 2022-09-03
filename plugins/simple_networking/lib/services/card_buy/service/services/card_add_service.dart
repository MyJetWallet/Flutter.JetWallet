import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/add/card_add_request_model.dart';
import '../../model/add/card_add_response_model.dart';
import '../card_buy_service.dart';

Future<CardAddResponseModel> cardAddService(
  Dio dio,
  CardAddRequestModel model,
  String localeName,
) async {
  final logger = CardBuyService.logger;
  const message = 'cardAddService';

  try {
    final response = await dio.post(
      '$walletApi/trading/buy/add-card',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);
      return CardAddResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
