import 'package:data_channel/data_channel.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/remote_config/data_sources/remote_config_data_sources.dart';
import 'package:simple_networking/modules/remote_config/models/remote_config_model.dart';

class RemoteConfigRepository {
  RemoteConfigRepository() {
    _validationApiDataSources = RemoteConfigDataSources();
  }

  late final RemoteConfigDataSources _validationApiDataSources;

  Future<DC<ServerRejectException, RemoteConfigModel>> getRemoteConfig(
    String url,
  ) async {
    return _validationApiDataSources.getRemoteConfigRequest(
      url,
    );
  }
}
