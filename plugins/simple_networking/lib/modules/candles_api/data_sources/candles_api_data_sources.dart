import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/modules/candles_api/models/candles_request_model.dart';
import 'package:simple_networking/modules/candles_api/models/candles_response_model.dart';

class CandlesApiDataSources {
  final ApiClient _apiClient;

  CandlesApiDataSources(this._apiClient);

  Future<DC<Exception, CandlesResponseModel>> getCandlesRequest(
    CandlesRequestModel model,
  ) async {
    try {
      final response = await _apiClient.get(
        '${_apiClient.options.candlesApi}/Candles/Candles/${model.type}',
        queryParameters: model.toJson(),
      );

      try {
        final responseData = response.data as List<dynamic>;

        return DC.data(CandlesResponseModel.fromList(responseData));
      } catch (e) {
        rethrow;
      }
    } on Exception catch (e) {
      return DC.error(e);
    }
  }
}
