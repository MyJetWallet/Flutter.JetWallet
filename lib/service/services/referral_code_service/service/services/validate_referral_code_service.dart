import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/validate_referral_code_request_model.dart';
import '../referral_code_service.dart';

Future<void> validateReferralCodeService(
    Dio dio,
    ValidateReferralCodeRequestModel model,
    ) async {
  final logger = ReferralCodeService.logger;
  const message = 'validateAddressService';

  try {
    final response = await dio.post(
      '$authApi/trader/VerifyReferralCode',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
