import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/phone_number/phone_number_response_model.dart';
import '../model/phone_verification/phone_verification_request_model.dart';
import '../model/phone_verification_verify/phone_verification_verify_request_model.dart';
import 'services/phone_number_service.dart';
import 'services/phone_verification_request_service.dart';
import 'services/phone_verification_verify_service.dart';

class PhoneVerificationService {
  PhoneVerificationService(this.dio);

  final Dio dio;

  static final logger = Logger('PhoneVerificationService');

  Future<void> request(PhoneVerificationRequestModel model) {
    return phoneVerificationRequestService(dio, model);
  }

  Future<void> verify(PhoneVerificationVerifyRequestModel model) {
    return phoneVerificationVerifyService(dio, model);
  }

  Future<PhoneNumberResponseModel> phoneNumber() {
    return phoneNumberService(dio);
  }
}
