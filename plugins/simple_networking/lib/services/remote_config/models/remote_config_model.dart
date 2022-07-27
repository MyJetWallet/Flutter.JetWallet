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
    @JsonKey(name: 'Analytics') required RemoteConfigAnalyticsModel analytics,
    @JsonKey(name: 'AppConfig') required RemoteConfigAppconfigModel appConfig,
    @JsonKey(name: 'AppsFlyer') required RemoteConfigAppsflyer appsFlyer,
    @JsonKey(name: 'Circle') required RemoteConfigCircle circle,
    @JsonKey(name: 'ConnectionFlavors')
        required List<RemoteConfigConnectionFlavorModel> connectionFlavors,
    @JsonKey(name: 'Simplex') required RemoteConfogSimplexModel simplex,
    @JsonKey(name: 'Support') required RemoteConfigSupportModel support,
    @JsonKey(name: 'Versioning')
        required RemoteConfogVersioningModel versioning,
  }) = _RemoteConfigModel;

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigModelFromJson(json);
}
