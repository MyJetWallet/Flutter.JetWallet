import 'package:dio/dio.dart';

import '../model/get_candles/candles_request_model.dart';
import '../model/get_candles/candles_response_model.dart';
import 'services/candles_service.dart';

class ChartService {
  ChartService(this.dio);

  final Dio dio;

  Future<CandlesResponseModel> candles(
    CandlesRequestModel model,
  ) {
    return candlesService(dio, model);
  }
}
