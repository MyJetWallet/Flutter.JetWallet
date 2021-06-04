import 'package:dio/dio.dart';
import '../model/register_token_request_model.dart';

import 'services/register_token_service.dart';

class NotificationService {
  NotificationService(this.dio);

  final Dio dio;

  Future<Map<String, dynamic>> registerToken(
    RegisterTokenRequestModel model,
  ) {
    return registerTokenService(dio, model);
  }
}
