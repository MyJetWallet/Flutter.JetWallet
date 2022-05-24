import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/register_token_request_model.dart';
import 'services/register_token_service.dart';

class NotificationService {
  NotificationService(this.dio);

  final Dio dio;

  static final logger = Logger('NotificationService');

  Future<void> registerToken(
    RegisterTokenRequestModel model,
    String localeName,
  ) {
    return registerTokenService(dio, model, localeName);
  }
}
