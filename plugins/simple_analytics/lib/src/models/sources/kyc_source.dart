// TODO(Denis Martych): FIX this, it isn't Source, it's property
enum KycSource {
  kycAllowCameraView,
  kycUploadIdentityDocumentView,
  kycSelfieView,
  kycSuccessPageView,
  kycPhoneConfirmationView,
}

extension KycSourceExtension on KycSource {
  String get name {
    switch (this) {
      case KycSource.kycAllowCameraView:
        return 'KYC - Allow camera view';
      case KycSource.kycUploadIdentityDocumentView:
        return 'KYC - Upload identity document view';
      case KycSource.kycSelfieView:
        return 'KYC - Take a selfie view';
      case KycSource.kycSuccessPageView:
        return 'KYC - Success page view';
      case KycSource.kycPhoneConfirmationView:
        return 'KYC - Phone confirmation view';
    }
  }
}

enum KycScope {
  phone,
  identity,
  phoneIdentity,
  kycCameraAllowed,
  kycCameraNotAllowed,
  kycIdentityUploaded,
  kycIdentityUploadFailed,
  kycSelfieUpload,
}

extension KycScopeExtension on KycScope {
  String get name {
    switch (this) {
      case KycScope.phone:
        return 'Phone';
      case KycScope.identity:
        return 'Identity';
      case KycScope.phoneIdentity:
        return 'Phone + Identity';
      case KycScope.kycCameraAllowed:
        return 'KYC - Camera allowed';
      case KycScope.kycCameraNotAllowed:
        return 'KYC - Camera not allowed';
      case KycScope.kycIdentityUploaded:
        return 'KYC - Identity Uploaded';
      case KycScope.kycIdentityUploadFailed:
        return 'KYC - Identity upload failed';
      case KycScope.kycSelfieUpload:
        return 'KYC - Selfie uploaded';
    }
  }
}
