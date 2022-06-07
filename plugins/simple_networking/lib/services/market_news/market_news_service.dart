import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/market_news_request_model.dart';
import 'model/market_news_response_model.dart';
import 'services/market_news_service.dart';

class MarketNewsService {
  MarketNewsService(this.dio);

  final Dio dio;

  static final logger = Logger('NewsService');

  Future<MarketNewsResponseModel> marketNews(MarketNewsRequestModel model) {
    return marketNewsService(dio, model);
  }
}
