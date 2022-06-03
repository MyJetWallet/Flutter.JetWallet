import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/validate_referral_code_request_model.dart';
import 'services/validate_referral_code_service.dart';

class ReferralCodeService {
  ReferralCodeService(this.dio);

  final Dio dio;

  static final logger = Logger('ReferralCodeService');

  Future<void> validateReferralCode(
    ValidateReferralCodeRequestModel model,
    String localeName,
  ) {
    return validateReferralCodeService(dio, model, localeName);
  }
}
