import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/session_info_response_model.dart';
import 'services/session_info_service.dart';

class InfoService {
  InfoService(this.dio);

  static final logger = Logger('InfoService');

  final Dio dio;

  Future<SessionInfoResponseModel> sessionInfo(String localeName) {
    return sessionInfoService(
      dio,
      localeName,
    );
  }
}
