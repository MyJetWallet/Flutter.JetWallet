import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import '../../model/calculate_earn_offer_apy/calculate_earn_offer_apy_response_model.dart';
import '../high_yield_service.dart';

Future<CalculateEarnOfferApyResponseModel> calculateEarnOfferApyService(
  Dio dio,
  CalculateEarnOfferApyRequestModel model,
  String localeName,
) async {
  final logger = HighYieldService.logger;
  const message = 'calculateEarnOfferApyService';

  try {
    final response = await dio.post(
      '$walletApi/trading/high-yield/calculate-earn-offer-apy',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return CalculateEarnOfferApyResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
