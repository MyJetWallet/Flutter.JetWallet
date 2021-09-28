import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/sms_verification/sms_verification_request.dart';
import '../model/sms_verification_verify/sms_verification_verify_request.dart';
import 'services/sms_verification_request_service.dart';
import 'services/sms_verification_verify_service.dart';

class SmsVerificationService {
  SmsVerificationService(this.dio);

  final Dio dio;

  static final logger = Logger('SmsVerificationService');

  Future<void> request(SmsVerificationRequest model) {
    return smsVerificationRequestService(dio, model);
  }

  Future<void> verify(SmsVerificationVerifyRequest model) {
    return smsVerificationVerifyService(dio, model);
  }
}
