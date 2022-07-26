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
    final response = await dio.post(
      '$walletApi/trading/buy/execute',
      data: model.toJson(),
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
