import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../model/get_candles/candles_request_model.dart';
import '../../model/get_candles/candles_response_model.dart';

Future<CandlesResponseModel> getCandlesService(
    Dio dio,
    CandlesRequestModel model,
    ) async {
  final response = await dio.get(
    '$tradingBaseUrl/PriceHistory/Candles',
    queryParameters: model.toJson(),
  );

  final responseData = response.data as List<dynamic>;

  return CandlesResponseModel.fromList(responseData);
}