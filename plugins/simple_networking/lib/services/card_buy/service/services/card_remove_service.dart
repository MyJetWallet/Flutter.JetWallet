import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/remove/card_remove_request_model.dart';
import '../../model/remove/card_remove_response_model.dart';
import '../card_buy_service.dart';

Future<CardRemoveResponseModel> cardRemoveService(
  Dio dio,
  CardRemoveRequestModel model,
  String localeName,
) async {
  final logger = CardBuyService.logger;
  const message = 'cardRemoveService';

  try {
    final response = await dio.post(
      '$walletApi/trading/buy/delete-card',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);
      return CardRemoveResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
