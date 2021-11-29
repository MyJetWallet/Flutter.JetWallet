import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/education_news_request_model.dart';
import 'model/education_news_response_model.dart';
import 'services/education_news_service.dart';

class EducationNewsService {
  EducationNewsService(this.dio);

  final Dio dio;

  static final logger = Logger('EducationNewsService');

  Future<EducationNewsResponseModel> educationNews(
    EducationNewsRequestModel model,
  ) {
    return educationNewsService(dio, model);
  }
}
