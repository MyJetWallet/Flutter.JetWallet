import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

enum KycStatus {
  kycRequired,
  kycInProgress,
  allowed,
  allowedWithKycAlert,
  blocked
}

int kycOperationStatus(KycStatus status) {
  switch (status) {
    case KycStatus.kycRequired:
      return 0;
    case KycStatus.kycInProgress:
      return 1;
    case KycStatus.allowed:
      return 2;
    case KycStatus.allowedWithKycAlert:
      return 3;
    case KycStatus.blocked:
      return 4;
  }
}

enum RequiredVerified {
  proofOfIdentity,
  proofOfAddress,
  proofOfFunds,
  proofOfPhone,
}

String stringRequiredVerified(
  RequiredVerified type,
) {
  switch (type) {
    case RequiredVerified.proofOfIdentity:
      return intl.kycOperationStatus_verifyYourIdentity;
    case RequiredVerified.proofOfAddress:
      return intl.kycOperationStatus_addressVerification;
    case RequiredVerified.proofOfFunds:
      return intl.kycOperationStatus_proofSourceOfFunds;
    case RequiredVerified.proofOfPhone:
      return intl.kycOperationStatus_secureYourAccount;
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
  selfieWithCard,
  creditCard,
}

String stringKycDocumentType(
  KycDocumentType type,
  BuildContext context,
) {
  switch (type) {
    case KycDocumentType.unknown:
      return 'unknown';
    case KycDocumentType.governmentId:
      return intl.kycDocumentType_governmentId;
    case KycDocumentType.passport:
      return intl.kycDocumentType_passport;
    case KycDocumentType.driverLicense:
      return intl.kycDocumentType_driverLicense;
    case KycDocumentType.residentPermit:
      return intl.kycDocumentType_residentPermit;
    case KycDocumentType.selfieImage:
      return intl.kycDocumentType_selfieImage;
    case KycDocumentType.addressDocument:
      return intl.kycDocumentType_addressDocument;
    default:
      return intl.kycDocumentType_financialDocument;
  }
}

Widget iconKycDocumentType(
  KycDocumentType type,
  BuildContext context,
) {
  switch (type) {
    case KycDocumentType.governmentId:
      return const SDocumentIcon();
    case KycDocumentType.passport:
      return const SPassportIcon();
    case KycDocumentType.driverLicense:
      return const SDriverLicenseIcon();
    case KycDocumentType.residentPermit:
      return const SResidentIcon();
    default:
      return const SDocumentIcon();
  }
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

int kycDocumentTypeInt(KycDocumentType type) {
  switch (type) {
    case KycDocumentType.unknown:
      return 0;
    case KycDocumentType.governmentId:
      return 1;
    case KycDocumentType.passport:
      return 2;
    case KycDocumentType.driverLicense:
      return 3;
    case KycDocumentType.residentPermit:
      return 4;
    case KycDocumentType.selfieImage:
      return 5;
    case KycDocumentType.addressDocument:
      return 6;
    case KycDocumentType.financialDocument:
      return 7;
    case KycDocumentType.selfieWithCard:
      return 8;
    case KycDocumentType.creditCard:
      return 9;
  }
}

enum KycStatusType {
  deposit,
  withdrawal,
  sell,
}

enum ActiveScanButton {
  active,
  notActive,
}

bool activeScanButtonType(ActiveScanButton type) {
  switch (type) {
    case ActiveScanButton.active:
      return true;
    case ActiveScanButton.notActive:
      return false;
  }
}
