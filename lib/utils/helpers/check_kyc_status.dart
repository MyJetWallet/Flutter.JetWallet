import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';

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

bool checkKycBlocked(
  int depositStatus,
  int sellStatus,
  int withdrawalStatus,
) {
  if (depositStatus == kycOperationStatus(KycStatus.blocked) ||
      sellStatus == kycOperationStatus(KycStatus.blocked) ||
      withdrawalStatus == kycOperationStatus(KycStatus.blocked)) {
    return true;
  }

  return false;
}

bool checkKycRequired(
  int depositStatus,
  int sellStatus,
  int withdrawalStatus,
) {
  if (depositStatus == kycOperationStatus(KycStatus.kycRequired) ||
      sellStatus == kycOperationStatus(KycStatus.kycRequired) ||
      withdrawalStatus == kycOperationStatus(KycStatus.kycRequired)) {
    return true;
  }

  return false;
}
