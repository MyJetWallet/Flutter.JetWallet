import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/send_email_verification_code_request_model.dart';
import '../model/verify_email_verification_code_request_model.dart';
import '../model/verify_withdrawal_verification_code_request_model.dart';
import 'services/send_email_verification_code_service.dart';
import 'services/verify_email_verification_code_service.dart';
import 'services/verify_transfer_verification_code_service.dart';
import 'services/verify_withdrawal_verification_code_service.dart';

class ValidationService {
  ValidationService(this.dio);

  final Dio dio;

  static final logger = Logger('ValidationService');

  Future<void> sendEmailVerificationCode(
    SendEmailVerificationCodeRequestModel model,
    String localeName,
  ) {
    return sendEmailVerificationCodeService(dio, model, localeName);
  }

  Future<void> verifyEmailVerificationCode(
    VerifyEmailVerificationCodeRequestModel model,
    String localeName,
  ) {
    return verifyEmailVerificationCodeService(dio, model, localeName);
  }

  Future<void> verifyWithdrawalVerificationCode(
    VerifyWithdrawalVerificationCodeRequestModel model,
    String localeName,
  ) {
    return verifyWithdrawalVerificationCodeService(dio, model, localeName);
  }

  Future<void> verifyTransferVerificationCode(
    VerifyWithdrawalVerificationCodeRequestModel model,
    String localeName,
  ) {
    return verifyTransferVerificationCodeService(dio, model, localeName);
  }
}
