import 'package:dio/dio.dart';

import '../model/get_candles/candles_request_model.dart';
import '../model/get_candles/candles_response_model.dart';
import 'services/get_candles_service.dart';

class ChartsService {
  ChartsService(this.dio);

  final Dio dio;

  Future<CandlesResponseModel> getCandles(
    CandlesRequestModel model,
  ) {
    return getCandlesService(dio, model);
  }
}
