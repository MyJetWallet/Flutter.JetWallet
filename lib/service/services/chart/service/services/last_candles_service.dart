import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/candles_response_model.dart';
import '../../model/last_candles_request_model.dart';
import '../chart_service.dart';

Future<CandlesResponseModel> lastCandlesService(
  Dio dio,
  LastCandlesRequestModel model,
) async {
  final logger = ChartService.logger;
  const message = 'lastCandlesService';

  try {
    final response = await dio.get(
      '$tradingApi/Candles/LastCandles/${model.instrumentId}/${model.type}',
      queryParameters: model.toJson(),
    );

    try {
      final responseData = response.data as List<dynamic>;

      return CandlesResponseModel.fromList(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
