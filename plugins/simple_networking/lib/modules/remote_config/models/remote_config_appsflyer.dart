import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_appsflyer.freezed.dart';
part 'remote_config_appsflyer.g.dart';

///
/// TODO: delete default value!!!
///

@freezed
class RemoteConfigAppsflyer with _$RemoteConfigAppsflyer {
  factory RemoteConfigAppsflyer({
    required String devKey,
    required String iosAppId,
    @Default('app.simple.com') String androidAppId,
  }) = _RemoteConfigAppsflyer;

  factory RemoteConfigAppsflyer.fromJson(Map<String, dynamic> json) => _$RemoteConfigAppsflyerFromJson(json);
}
