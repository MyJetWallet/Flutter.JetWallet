import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/two_fa_disable/two_fa_disable_request_model.dart';
import '../model/two_fa_enable/two_fa_enable_request_model.dart';
import '../model/two_fa_verification/two_fa_verification_request_model.dart';
import '../model/two_fa_verify/two_fa_verify_request_model.dart';
import 'services/two_fa_disable_service.dart';
import 'services/two_fa_enable_service.dart';
import 'services/two_fa_request_disable_service.dart';
import 'services/two_fa_request_enable_service.dart';
import 'services/two_fa_request_verification_service.dart';
import 'services/two_fa_verify_service.dart';

class TwoFaService {
  TwoFaService(this.dio);

  final Dio dio;

  static final logger = Logger('TwoFaService');

  Future<void> requestVerification(
    TwoFaVerificationRequestModel model,
    String localeName,
  ) {
    return twoFaRequestVerificationService(dio, model, localeName);
  }

  Future<void> requestEnable(
    TwoFaVerificationRequestModel model,
    String localeName,
  ) {
    return twoFaRequestEnableService(dio, model, localeName);
  }

  Future<void> requestDisable(
    TwoFaVerificationRequestModel model,
    String localeName,
  ) {
    return twoFaRequestDisableService(dio, model, localeName);
  }

  Future<void> verify(TwoFaVerifyRequestModel model, String localeName) {
    return twoFaVerifyService(dio, model, localeName);
  }

  Future<void> enable(TwoFaEnableRequestModel model, String localeName) {
    return twoFaEnableService(dio, model, localeName);
  }

  Future<void> disable(TwoFaDisableRequestModel model, String localeName) {
    return twoFaDisableService(dio, model, localeName);
  }
}
