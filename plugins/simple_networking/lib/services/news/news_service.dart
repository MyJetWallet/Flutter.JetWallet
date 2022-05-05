import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/news_request_model.dart';
import 'model/news_response_model.dart';
import 'services/news_service.dart';

class NewsService {
  NewsService(this.dio);

  final Dio dio;

  static final logger = Logger('NewsService');

  Future<NewsResponseModel> news(
    NewsRequestModel model,
  ) {
    return newsService(dio, model);
  }
}
