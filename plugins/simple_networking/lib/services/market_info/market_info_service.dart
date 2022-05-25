import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/market_info_request_model.dart';
import 'model/market_info_response_model.dart';
import 'services/market_info_service.dart';

class MarketInfoService {
  MarketInfoService(this.dio);

  final Dio dio;

  static final logger = Logger('MarketInfoService');

  Future<MarketInfoResponseModel> marketInfo(
    MarketInfoRequestModel model,
    String localeName,
  ) {
    return marketInfoService(dio, model);
  }
}
