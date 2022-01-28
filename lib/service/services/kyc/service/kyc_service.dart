import 'package:dio/dio.dart';

import '../model/check_response_model.dart';
import 'services/check_service.dart';
import 'services/start_service.dart';

class KycService {
  KycService(this.dio);
  final Dio dio;

  Future<CheckResponseModel> check() async {
    return checkService(dio);
  }

  Future<void> start() async {
    return startService(dio);
  }
}
