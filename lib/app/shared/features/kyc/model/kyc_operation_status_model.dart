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

enum RequiredVerified {
  proofOfIdentity,
  proofOfAddress,
  proofOfFunds,
  proofOfPhone,
}

String stringRequiredVerified(RequiredVerified type) {
  switch (type) {
    case RequiredVerified.proofOfIdentity:
      return 'Verify your identity';
    case RequiredVerified.proofOfAddress:
      return 'Address verification';
    case RequiredVerified.proofOfFunds:
      return 'Proof source of funds';
    case RequiredVerified.proofOfPhone:
      return 'Secure your account';
  }
}

RequiredVerified requiredVerifiedStatus(int num) {
  switch (num) {
    case 1:
      return RequiredVerified.proofOfIdentity;
    case 2:
      return RequiredVerified.proofOfAddress;
    case 3:
      return RequiredVerified.proofOfFunds;
    default:
      return RequiredVerified.proofOfPhone;
  }
}


enum KycDocumentType {
  unknown,
  governmentId,
  passport,
  driverLicense,
  residentPermit,
  selfieImage,
  addressDocument,
  financialDocument,
}

 KycDocumentType kycDocumentType(int type) {
  switch (type) {
    case 0:
      return KycDocumentType.unknown;
    case 1:
      return KycDocumentType.governmentId;
    case 2:
      return KycDocumentType.passport;
    case 3:
      return KycDocumentType.driverLicense;
    case 4:
      return KycDocumentType.residentPermit;
    case 5:
      return KycDocumentType.selfieImage;
    case 6:
      return KycDocumentType.addressDocument;
    case 7:
      return KycDocumentType.financialDocument;
    default:
      return KycDocumentType.unknown;
  }
}

enum KycStatusType {
  deposit,
  withdrawal,
  sell,
}
