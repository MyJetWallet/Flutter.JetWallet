import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/sms_verification_verify/sms_verification_verify_request_model.dart';
import '../sms_verification.dart';

Future<void> smsVerificationVerifyService(
  Dio dio,
  SmsVerificationVerifyRequestModel model,
) async {
  final logger = SmsVerificationService.logger;
  const message = 'smsVerificationVerifyService';

  try {
    final response = await dio.post(
      '$validationApi/sms-verification/verify',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
