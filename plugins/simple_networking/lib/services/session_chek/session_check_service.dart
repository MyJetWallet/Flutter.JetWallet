import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/session_check_response_model.dart';
import 'service/session_check.dart';


class SessionCheckService {
  SessionCheckService(this.dio);

  final Dio dio;

  static final logger = Logger('SessionCheckService');

  Future<SessionCheckResponseModel> sessionCheck(
    String localeName,
  ) {
    return sessionCheckService(dio, localeName);
  }
}
