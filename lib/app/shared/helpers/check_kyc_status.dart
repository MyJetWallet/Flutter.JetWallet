import '../features/kyc/model/kyc_operation_status_model.dart';

bool checkKycPassed(
  int depositStatus,
  int sellStatus,
  int withdrawalStatus,
) {
  if (depositStatus == kycOperationStatus(KycStatus.allowed) &&
          sellStatus == kycOperationStatus(KycStatus.allowed) &&
          withdrawalStatus == kycOperationStatus(KycStatus.allowed)) {
    return true;
  }
  return false;
}

bool kycInProgress(
    int depositStatus,
    int sellStatus,
    int withdrawalStatus,
    ) {
  if (depositStatus == kycOperationStatus(KycStatus.kycInProgress) ||
      sellStatus == kycOperationStatus(KycStatus.kycInProgress) ||
      withdrawalStatus == kycOperationStatus(KycStatus.kycInProgress)) {
    return true;
  }
  return false;
}
