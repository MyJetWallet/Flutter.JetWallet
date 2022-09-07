import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/execute/card_buy_execute_request_model.dart';
import '../card_buy_service.dart';

Future<void> cardBuyExecuteService(
    Dio dio,
    CardBuyExecuteRequestModel model,
    String localeName,
    ) async {
  final logger = CardBuyService.logger;
  const message = 'cardBuyExecutePayment';

  try {
    final jsonModel = model.toJson();
    if (model.cardPaymentData != null) {
      final jsonCardModel = model.cardPaymentData!.toJson();
      jsonModel.remove('cardPaymentData');
      if (model.cardPaymentData!.expMonth == null) {
        jsonCardModel.remove('expMonth');
      }
      if (model.cardPaymentData!.expYear == null) {
        jsonCardModel.remove('expYear');
      }
      if (model.cardPaymentData!.isActive == null) {
        jsonCardModel.remove('isActive');
      }
      jsonModel.addAll({
        'cardPaymentData': jsonCardModel,
      });
    }
    final response = await dio.post(
      '$walletApi/trading/buy/execute',
      data: jsonModel,
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
