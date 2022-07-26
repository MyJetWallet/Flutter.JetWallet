import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/send_email_confirmation_request.dart';
import 'model/send_email_confirmation_response.dart';
import 'model/verify_email_confirmation_request.dart';
import 'service/send_email_confirmation_code_service.dart';
import 'service/verify_email_confirmation_service.dart';

class ConfirmationService {
  ConfirmationService(this.dio);

  final Dio dio;

  static final logger = Logger('ValidationService');

  Future<SendEmailConfirmationResponse> sendEmailConfirmationCode(
    SendEmailConfirmationRequest model,
    String localeName,
  ) {
    return sendEmailConfirmationCodeService(dio, model, localeName);
  }

  Future<void> verifyEmailConfirmation(
    VerifyEmailConfirmationRequest model,
    String localeName,
  ) {
    return verifyEmailConfirmationService(dio, model, localeName);
  }
}
