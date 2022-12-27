import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';

class LogsApiDataSources {
  final ApiClient _apiClient;

  LogsApiDataSources(this._apiClient);

  Future<DC<Exception, bool>> postAddLogRequest(
    AddLogModel model,
  ) async {
    try {
      final _ = await _apiClient.post(
        '${_apiClient.options.walletApi}/logs/add-log',
        data: model.toJson(),
      );

      try {
        return DC.data(true);
      } catch (e) {
        rethrow;
      }
    } on Exception catch (e) {
      return DC.error(e);
    }
  }
}
