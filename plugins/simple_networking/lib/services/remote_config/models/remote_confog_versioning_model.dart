import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_confog_versioning_model.freezed.dart';
part 'remote_confog_versioning_model.g.dart';

@freezed
class RemoteConfogVersioningModel with _$RemoteConfogVersioningModel {
  factory RemoteConfogVersioningModel({
    required String recommendedVersion,
    required String minimumVersion,
  }) = _RemoteConfogVersioningModel;

  factory RemoteConfogVersioningModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfogVersioningModelFromJson(json);
}
