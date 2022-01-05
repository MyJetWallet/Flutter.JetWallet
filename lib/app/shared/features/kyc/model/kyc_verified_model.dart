import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_verified_model.freezed.dart';

@freezed
class KycVerifiedModel with _$KycVerifiedModel {
  const factory KycVerifiedModel({
    @Default(0) int depositStatus,
    @Default(0) int tradeStatus,
    @Default(0) int withdrawalStatus,
    @Default([]) List<int> requiredDocuments,
    @Default([]) List<int> requiredVerifications,
  }) = _KycVerifiedModel;
}

enum KycOperationStatus {
  kycRequired,
  kycInProgress,
  allowed,
  allowedWithKycAlert,
  blocked
}

int kycOperationStatus(KycOperationStatus status) {
  switch (status) {
    case KycOperationStatus.kycRequired:
      return 0;
    case KycOperationStatus.kycInProgress:
      return 1;
    case KycOperationStatus.allowed:
      return 2;
    case KycOperationStatus.allowedWithKycAlert:
      return 3;
    case KycOperationStatus.blocked:
      return 4;
  }
}
