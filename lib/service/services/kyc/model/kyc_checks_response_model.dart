import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_checks_response_model.freezed.dart';
part 'kyc_checks_response_model.g.dart';

@freezed
class KycChecksResponseModel with _$KycChecksResponseModel {
  const factory KycChecksResponseModel({
    @Default([]) List<int> requiredVerifications,
    @Default([]) List<int> allowedDocuments,
    @Default(false) bool verificationInProgress,
  }) = _KycChecksResponseModel;

  factory KycChecksResponseModel.fromJson(Map<String, dynamic> json) =>
      _$KycChecksResponseModelFromJson(json);
}
