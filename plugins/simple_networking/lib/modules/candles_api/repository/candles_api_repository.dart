import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/modules/candles_api/data_sources/candles_api_data_sources.dart';
import 'package:simple_networking/modules/candles_api/models/candles_request_model.dart';
import 'package:simple_networking/modules/candles_api/models/candles_response_model.dart';

class CandlesApiRepository {
  CandlesApiRepository(this._apiClient) {
    _candlesApiDataSources = CandlesApiDataSources(_apiClient);
  }

  final ApiClient _apiClient;
  late final CandlesApiDataSources _candlesApiDataSources;

  Future<DC<Exception, CandlesResponseModel>> getCandles(
    CandlesRequestModel model,
  ) async {
    return _candlesApiDataSources.getCandlesRequest(
      model,
    );
  }
}
