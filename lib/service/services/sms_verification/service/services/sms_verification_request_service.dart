import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/sms_verification/sms_verification_request.dart';
import '../sms_verification.dart';

Future<void> smsVerificationRequestService(
  Dio dio,
  SmsVerificationRequest model,
) async {
  final logger = SmsVerificationService.logger;
  const message = 'smsVerificationRequestService';

  try {
    final response = await dio.post(
      '$validationApi/sms-verification/request',
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
