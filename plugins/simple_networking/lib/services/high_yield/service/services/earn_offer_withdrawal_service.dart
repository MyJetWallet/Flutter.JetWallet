import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/earn_offer_withdrawal/earn_offer_withdrawal_request_model.dart';
import '../high_yield_service.dart';

Future<void> earnOfferWithdrawalService(
  Dio dio,
  EarnOfferWithdrawalRequestModel model,
  String localeName,
) async {
  final logger = HighYieldService.logger;
  const message = 'earnOfferWithdrawalService';

  try {
    final response = await dio.post(
      '$walletApi/trading/high-yield/earn-offer-withdrawal',
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
