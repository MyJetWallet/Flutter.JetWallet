enum ScreenSource {
  assetScreen,
  quickActions,
  accountBanner,
  emptyPortfolioScreen,
  earnProgram,
  kycAllowCameraView,
  kycUploadIdentityDocumentView,
  kycSelfieView,
  kycSuccessPageView,
  kycPhoneConfirmationView
}

extension KycSourceExtension on ScreenSource {
  String get name {
    switch (this) {
      case ScreenSource.assetScreen:
        return 'Asset screen';
      case ScreenSource.quickActions:
        return 'Quick actions';
      case ScreenSource.accountBanner:
        return 'Account banner';
      case ScreenSource.emptyPortfolioScreen:
        return 'Empty portfolio screen';
      case ScreenSource.earnProgram:
        return 'Earn program';
      case ScreenSource.kycAllowCameraView:
        return 'KYC - Allow camera view';
      case ScreenSource.kycUploadIdentityDocumentView:
        return 'KYC - Upload identity document view';
      case ScreenSource.kycSelfieView:
        return 'KYC - Take a selfie view';
      case ScreenSource.kycSuccessPageView:
        return 'KYC - Success page view';
      case ScreenSource.kycPhoneConfirmationView:
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
