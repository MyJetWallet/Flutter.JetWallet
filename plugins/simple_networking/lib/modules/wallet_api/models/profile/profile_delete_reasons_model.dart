import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_delete_reasons_model.freezed.dart';
part 'profile_delete_reasons_model.g.dart';

@freezed
class ProfileDeleteReasonsModel with _$ProfileDeleteReasonsModel {
  factory ProfileDeleteReasonsModel({
    String? reasonId,
    String? reasonText,
  }) = _ProfileDeleteReasonsModel;

  factory ProfileDeleteReasonsModel.fromJson(Map<String, dynamic> json) => _$ProfileDeleteReasonsModelFromJson(json);
}
