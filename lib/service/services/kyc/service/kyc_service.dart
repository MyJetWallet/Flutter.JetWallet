import 'package:dio/dio.dart';

import '../model/kyc_checks_response_model.dart';
import 'services/kyc_checks_service.dart';
import 'services/kyc_start_service.dart';

class KycService {
  KycService(this.dio);
  final Dio dio;

  Future<KycChecksResponseModel> kycChecks() async {
    return kycChecksService(dio);
  }

  Future<void> kycStart() async {
    return kycStartService(dio);
  }

}
