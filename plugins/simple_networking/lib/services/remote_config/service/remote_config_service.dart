import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../models/remote_config_model.dart';
import 'services/get_remote_config_service.dart';

class RemoteConfigService {
  RemoteConfigService() {
    dio = Dio();

    dio.options.headers['accept'] = 'application/json';
    dio.options.headers['content-Type'] = 'application/json';
  }

  late final Dio dio;

  static final logger = Logger('RemoteConfigService');

  Future<RemoteConfigModel> getRemoteConfig(
    String url,
    String localeName,
  ) {
    return getRemoteConfigService(url, dio, localeName);
  }
}
