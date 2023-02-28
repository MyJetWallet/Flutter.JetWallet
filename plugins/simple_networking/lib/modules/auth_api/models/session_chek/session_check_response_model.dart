import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_check_response_model.freezed.dart';
part 'session_check_response_model.g.dart';

@freezed
class SessionCheckResponseModel with _$SessionCheckResponseModel {
  const factory SessionCheckResponseModel({
    required String? result,
    required bool toSetupPin,
    required bool toCheckPin,
    required bool toCheckSimpleKyc,
    required bool toCheckSelfie,
    required bool toSetupPhone,
  }) = _SessionCheckResponseModel;

  factory SessionCheckResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SessionCheckResponseModelFromJson(json);
}
