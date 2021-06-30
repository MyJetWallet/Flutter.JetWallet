import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/send_email_verification_code_request_model.dart';
import '../model/verify_email_verification_code_request_model.dart';
import 'services/send_email_verification_code_service.dart';
import 'services/verify_email_verification_code_service.dart';

class ValidationService {
  ValidationService(this.dio);

  final Dio dio;

  static final logger = Logger('ValidationService');

  Future<void> sendEmailVerificationCode(
    SendEmailVerificationCodeRequestModel model,
  ) {
    return sendEmailVerificationCodeService(dio, model);
  }

  Future<void> verifyEmailVerificationCode(
    VerifyEmailVerificationCodeRequestModel model,
  ) {
    return verifyEmailVerificationCodeService(dio, model);
  }
}
