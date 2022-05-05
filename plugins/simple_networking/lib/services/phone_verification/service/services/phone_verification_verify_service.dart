import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/phone_verification_verify/phone_verification_verify_request_model.dart';
import '../phone_verification_service.dart';

Future<void> phoneVerificationVerifyService(
  Dio dio,
  PhoneVerificationVerifyRequestModel model,
) async {
  final logger = PhoneVerificationService.logger;
  const message = 'phoneVerificationVerifyService';

  try {
    final response = await dio.post(
      '$validationApi/phone-setup/verify',
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
