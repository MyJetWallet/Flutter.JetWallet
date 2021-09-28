import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/two_fa_change/two_fa_change_request_model.dart';
import '../model/two_fa_disable/two_fa_disable_request_model.dart';
import '../model/two_fa_enable/two_fa_enable_request_model.dart';
import '../model/two_fa_verification/two_fa_verification_request_model.dart';
import '../model/two_fa_verify/two_fa_verify_request_model.dart';
import 'services/two_fa_change_service.dart';
import 'services/two_fa_disable_service.dart';
import 'services/two_fa_enable_service.dart';
import 'services/two_fa_request_service.dart';
import 'services/two_fa_verify_service.dart';

class TwoFaService {
  TwoFaService(this.dio);

  final Dio dio;

  static final logger = Logger('TwoFaVerification');

  Future<void> change(TwoFaChangeRequestModel model) {
    return twoFaChangeService(dio, model);
  }

  Future<void> disable(TwoFaDisableRequestModel model) {
    return twoFaDisableService(dio, model);
  }

  Future<void> enable(TwoFaEnableRequestModel model) {
    return twoFaEnableService(dio, model);
  }

  Future<void> request(TwoFaVerificationRequestModel model) {
    return twoFaRequestService(dio, model);
  }

  Future<void> verify(TwoFaVerifyRequestModel model) {
    return twoFaVerifyService(dio, model);
  }
}
