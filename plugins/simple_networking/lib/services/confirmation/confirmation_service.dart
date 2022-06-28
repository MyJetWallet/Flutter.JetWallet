import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/confirmation/service/verify_email_confirmation_service.dart';

import '../validation/model/send_email_verification_code_request_model.dart';
import '../validation/model/verify_email_verification_code_request_model.dart';
import 'service/send_email_confirmation_code_service.dart';

class ConfirmationService {
  ConfirmationService(this.dio);

  final Dio dio;

  static final logger = Logger('ValidationService');

  Future<void> sendEmailConfirmationCode(
    SendEmailVerificationCodeRequestModel model,
    String localeName,
  ) {
    return sendEmailConfirmationCodeService(dio, model, localeName);
  }

  Future<void> verifyEmailConfirmation(
    VerifyEmailVerificationCodeRequestModel model,
    String localeName,
  ) {
    return verifyEmailConfirmationService(dio, model, localeName);
  }
}
