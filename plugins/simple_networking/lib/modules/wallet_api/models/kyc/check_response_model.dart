import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_response_model.freezed.dart';
part 'check_response_model.g.dart';

@freezed
class CheckResponseModel with _$CheckResponseModel {
  const factory CheckResponseModel({
    @Default([]) List<int> requiredVerifications,
    @Default([]) List<int> allowedDocuments,
    @Default(false) bool verificationInProgress,
  }) = _CheckResponseModel;

  factory CheckResponseModel.fromJson(Map<String, dynamic> json) => _$CheckResponseModelFromJson(json);
}
