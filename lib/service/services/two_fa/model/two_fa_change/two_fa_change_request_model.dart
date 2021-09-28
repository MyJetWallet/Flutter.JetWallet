import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_change_request_model.freezed.dart';
part 'two_fa_change_request_model.g.dart';

@freezed
class TwoFaChangeRequestModel with _$TwoFaChangeRequestModel {
  const factory TwoFaChangeRequestModel({
    required String language,
    required String deviceType,
  }) = _TwoFaChangeRequestModel;

  factory TwoFaChangeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TwoFaChangeRequestModelFromJson(json);
}
