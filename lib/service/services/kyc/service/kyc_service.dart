import 'package:dio/dio.dart';

import 'services/start_service.dart';

class KycService {
  KycService(this.dio);
  final Dio dio;

  Future<void> start() async {
    return startService(dio);
  }
}
