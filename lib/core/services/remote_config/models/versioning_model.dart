import 'package:freezed_annotation/freezed_annotation.dart';

part 'versioning_model.freezed.dart';
part 'versioning_model.g.dart';

@freezed
class VersioningModel with _$VersioningModel {
  const factory VersioningModel({
    required String recommendedVersion,
    required String minimumVersion,
  }) = _VersioningModel;

  factory VersioningModel.fromJson(Map<String, dynamic> json) => _$VersioningModelFromJson(json);
}
