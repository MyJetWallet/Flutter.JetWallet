import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_delete_reasons_request_model.freezed.dart';
part 'profile_delete_reasons_request_model.g.dart';

@freezed
class ProfileDeleteReasonsRequestModel with _$ProfileDeleteReasonsRequestModel {
  factory ProfileDeleteReasonsRequestModel({
    @JsonKey(name: 'lang') required String language,
  }) = _ProfileDeleteReasonsRequestModel;

  factory ProfileDeleteReasonsRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProfileDeleteReasonsRequestModelFromJson(json);
}
