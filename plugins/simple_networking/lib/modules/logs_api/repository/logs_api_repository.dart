import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/modules/logs_api/data_sources/logs_api_data_sources.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';

class LogsApiRepository {
  LogsApiRepository(this._apiClient) {
    _logsApiDataSources = LogsApiDataSources(_apiClient);
  }

  final ApiClient _apiClient;
  late final LogsApiDataSources _logsApiDataSources;

  Future<DC<Exception, bool>> postAddLog(
    AddLogModel model,
  ) async {
    return _logsApiDataSources.postAddLogRequest(
      model,
    );
  }
}
