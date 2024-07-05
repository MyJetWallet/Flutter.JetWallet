import 'package:freezed_annotation/freezed_annotation.dart';

part 'apps_flyer_model.freezed.dart';
part 'apps_flyer_model.g.dart';

@freezed
class AppsFlyerModel with _$AppsFlyerModel {
  const factory AppsFlyerModel({
    required String devKey,
    required String iosAppId,
  }) = _AppsFlyerModel;

  factory AppsFlyerModel.fromJson(Map<String, dynamic> json) => _$AppsFlyerModelFromJson(json);
}
