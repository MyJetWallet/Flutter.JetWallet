import 'package:dio/dio.dart';

import '../model/check_response_model.dart';
import 'services/check_service.dart';
import 'services/start_service.dart';

class KycService {
  KycService(
    this.dio,
    this.locale,
  );
  final Dio dio;
  final String locale;

  Future<CheckResponseModel> check() async {
    return checkService(dio, locale);
  }

  Future<void> start() async {
    return startService(dio);
  }
}
