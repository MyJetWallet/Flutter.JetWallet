import 'package:freezed_annotation/freezed_annotation.dart';

import 'remote_config_analytics_model.dart';
import 'remote_config_appconfig_model.dart';
import 'remote_config_appsflyer.dart';
import 'remote_config_circle.dart';
import 'remote_config_connection_flavor_model.dart';
import 'remote_config_support_model.dart';
import 'remote_confog_simplex_model.dart';
import 'remote_confog_versioning_model.dart';

part 'remote_config_model.freezed.dart';
part 'remote_config_model.g.dart';

@freezed
class RemoteConfigModel with _$RemoteConfigModel {
  factory RemoteConfigModel({
    @JsonKey(name: 'Analytics')
        required final RemoteConfigAnalyticsModel analytics,
    @JsonKey(name: 'AppConfig')
        required final RemoteConfigAppconfigModel appConfig,
    @JsonKey(name: 'AppsFlyer') required final RemoteConfigAppsflyer appsFlyer,
    @JsonKey(name: 'Circle') required final RemoteConfigCircle circle,
    @JsonKey(name: 'ConnectionFlavors')
        required final List<RemoteConfigConnectionFlavorModel>
            connectionFlavors,
    @JsonKey(name: 'Simplex') required final RemoteConfogSimplexModel simplex,
    @JsonKey(name: 'Support') required final RemoteConfigSupportModel support,
    @JsonKey(name: 'Versioning')
        required final RemoteConfogVersioningModel versioning,
  }) = _RemoteConfigModel;

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigModelFromJson(json);
}
