import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/earn_offer_deposit/earn_offer_deposit_request_model.dart';
import '../high_yield_service.dart';

Future<void> earnOfferDepositService(
  Dio dio,
  EarnOfferDepositRequestModel model,
  String localeName,
) async {
  final logger = HighYieldService.logger;
  const message = 'earnOfferDepositService';

  try {
    final response = await dio.post(
      '$walletApi/trading/high-yield/earn-offer-deposit',
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
