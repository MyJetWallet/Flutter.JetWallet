import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/api_urls.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../../authentication/service/authentication_service.dart';
import '../../model/verify_email_verification_code_request_model.dart';

Future<void> verifyEmailVerificationCodeService(
  Dio dio,
  VerifyEmailVerificationCodeRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'verifyEmailVerificationCodeService';

  try {
    final response = await dio.post(
      '$validationApi/email-verification/verify',
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
