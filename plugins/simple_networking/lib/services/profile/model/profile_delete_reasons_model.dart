import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_delete_reasons_model.freezed.dart';
part 'profile_delete_reasons_model.g.dart';

@freezed
class ProfileDeleteReasonsModel with _$ProfileDeleteReasonsModel {
  factory ProfileDeleteReasonsModel({
    required List<String> reasons,
  }) = _ProfileDeleteReasonsModel;

  factory ProfileDeleteReasonsModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDeleteReasonsModelFromJson(json);
}
/*
@freezed
class ProfileDeleteReasonModel with _$ProfileDeleteReasonsModel {
  factory ProfileDeleteReasonModel({
    String? value,
  }) = _ProfileDeleteReasonModel;

  factory ProfileDeleteReasonModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDeleteReasonModelFromJson(json);
}
*/