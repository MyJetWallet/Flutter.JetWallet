import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_appsflyer.freezed.dart';
part 'remote_config_appsflyer.g.dart';

@freezed
class RemoteConfigAppsflyer with _$RemoteConfigAppsflyer {
  factory RemoteConfigAppsflyer({
    required final String devKey,
    required final String iosAppId,
  }) = _RemoteConfigAppsflyer;

  factory RemoteConfigAppsflyer.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigAppsflyerFromJson(json);
}
