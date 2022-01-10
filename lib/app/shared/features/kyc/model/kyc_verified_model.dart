import 'package:freezed_annotation/freezed_annotation.dart';
import 'kyc_operation_status_model.dart';

part 'kyc_verified_model.freezed.dart';

@freezed
class KycVerifiedModel with _$KycVerifiedModel {
  const factory KycVerifiedModel({
    @Default(0) int depositStatus,
    @Default(0) int sellStatus,
    @Default(0) int withdrawalStatus,
    @Default([]) List<KycDocumentType> requiredDocuments,
    @Default([]) List<RequiredVerified> requiredVerifications,
    @Default(false) bool verificationInProgress,
  }) = _KycVerifiedModel;
}
