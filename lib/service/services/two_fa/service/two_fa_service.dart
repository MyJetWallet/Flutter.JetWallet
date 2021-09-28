import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/two_fa_change/two_fa_change_request.dart';
import '../model/two_fa_disable/two_fa_disable_request.dart';
import '../model/two_fa_enable/two_fa_enable_request.dart';
import '../model/two_fa_verification/two_fa_verification_request.dart';
import '../model/two_fa_verify/two_fa_verify_request.dart';
import 'services/two_fa_change_service.dart';
import 'services/two_fa_disable_service.dart';
import 'services/two_fa_enable_service.dart';
import 'services/two_fa_request_service.dart';
import 'services/two_fa_verify_service.dart';

class TwoFaService {
  TwoFaService(this.dio);

  final Dio dio;

  static final logger = Logger('TwoFaVerification');

  Future<void> change(TwoFaChangeRequest model) {
    return twoFaChangeService(dio, model);
  }

  Future<void> disable(TwoFaDisableRequest model) {
    return twoFaDisableService(dio, model);
  }

  Future<void> enable(TwoFaEnableRequest model) {
    return twoFaEnableService(dio, model);
  }

  Future<void> request(TwoFaVerificationRequest model) {
    return twoFaRequestService(dio, model);
  }

  Future<void> verify(TwoFaVerifyRequest model) {
    return twoFaVerifyService(dio, model);
  }
}
