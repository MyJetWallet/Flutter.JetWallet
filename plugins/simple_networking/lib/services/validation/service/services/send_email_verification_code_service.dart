import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../../authentication/service/authentication_service.dart';
import '../../model/send_email_verification_code_request_model.dart';

Future<void> sendEmailVerificationCodeService(
  Dio dio,
  SendEmailVerificationCodeRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'emailVerificationService';

  try {
    final response = await dio.post(
      '$validationApi/email-verification/request',
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
