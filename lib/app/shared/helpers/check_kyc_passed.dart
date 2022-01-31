import '../features/kyc/model/kyc_operation_status_model.dart';

bool checkKycPassed(
    int depositStatus,
    int sellStatus,
    int withdrawalStatus,
    ) {
  if (depositStatus == kycOperationStatus(KycOperationStatus.kycRequired) ||
      depositStatus ==
          kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
    return false;
  }

  if (sellStatus == kycOperationStatus(KycOperationStatus.kycRequired) ||
      sellStatus ==
          kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
    return false;
  }

  if (withdrawalStatus ==
      kycOperationStatus(KycOperationStatus.kycRequired) ||
      withdrawalStatus ==
          kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
    return false;
  }
  return true;
}
