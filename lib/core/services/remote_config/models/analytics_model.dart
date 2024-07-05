import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

@freezed
class AnalyticsModel with _$AnalyticsModel {
  const factory AnalyticsModel({
    required String apiKey,
  }) = _AnalyticsModel;

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => _$AnalyticsModelFromJson(json);
}
