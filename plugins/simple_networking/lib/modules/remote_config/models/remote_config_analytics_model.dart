import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_analytics_model.freezed.dart';
part 'remote_config_analytics_model.g.dart';

@freezed
class RemoteConfigAnalyticsModel with _$RemoteConfigAnalyticsModel {
  factory RemoteConfigAnalyticsModel({
    required String apiKey,
  }) = _RemoteConfigAnalyticsModel;

  factory RemoteConfigAnalyticsModel.fromJson(Map<String, dynamic> json) => _$RemoteConfigAnalyticsModelFromJson(json);
}
