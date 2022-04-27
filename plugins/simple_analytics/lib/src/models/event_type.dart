class EventType {
  /// User visits onboarding screen
  static const onboardingView = 'Onboarding view';

  /// User visits sign up page
  static const signUpView = 'Sign up view';
  static const signUpSuccess = 'Sign up';
  static const signUpFailure = 'Sign up failed';

  /// User visits email verification page
  static const emailVerificationView = 'Sign up - email verification view';

  /// User successfully confirmed email be entering verification code
  static const emailConfirmed = 'Sign up - email confirmed';

  /// User visits login page
  static const loginView = 'Login view';
  static const loginSuccess = 'Login';
  static const loginFailure = 'Login failed';

  /// User visits Asset details screen with Chart/About....
  static const assetView = 'Asset View';

  /// User visits Earn program screen (all assets + APY)
  static const earnProgramView = 'Earn program view';

  /// Logout action
  static const logout = 'Logout';

  /// Places where we call kyc popup
  static const kycVerifyProfile = 'KYC - Verify your profile';

  /// Change country code, send country name
  static const changeCountryCode = 'Change country code';

  /// Choose country name and document type in kyc
  static const identityParametersChoosed = 'Identity parameters choosed';

  /// Market filters
  static const marketFilters = 'Filters';

  /// Add asset to watchlist
  static const addToWatchlist = 'Add to watchlist';

  /// Click on market banner, close-open, campaign name
  static const clickMarketBanner = 'Market banner click';

  static const rewardsScreenView = 'Rewards screen view';

  static const inviteFriendView = 'Invite friend view';

  static const earnDetailsView = 'Earn details view';

  static const walletAssetView = 'Wallet asset view';

  /// Quick actions screens
  static const buyView = 'Buy view';
  static const sellView = 'Sell view';
  static const convertView = 'Convert view';
  static const depositView = 'Deposit view';
  static const receiveView = 'Receive view';
  static const sendView = 'Send view';
  static const buyFromCardView = 'Buy from card view';

  /// Quick actions bottom sheet
  static const buySheetView = 'Buy sheet view';
  static const sellSheetView = 'Sell sheet view';
  static const convertSheetView = 'Convert sheet view';
  static const depositSheetView = 'Deposit sheet view';
  static const receiveSheetView = 'Receive sheet view';
  static const sendSheetView = 'Send sheet view';
  static const buyFromCardSheetView = 'Buy from card sheet view';

  /// KYC related events
  static const kycCameraAllowed = 'KYC - Camera allowed';
  static const kycCameraNotAllowed = 'KYC - Camera not allowed';
  static const kycIdentityUploaded = 'KYC - Identity Uploaded';
  static const kycIdentityUploadFailed = 'KYC - Identity upload failed';
  static const kycSelfieUploaded = 'KYC - Selfie uploaded';
  static const kycPhoneConfirmationView = 'KYC - Phone confirmation view';
  static const kycPhoneConfirmed = 'KYC - Phone confirmed';
  static const kycPhoneConfirmFailed = 'KYC - Phone confirm failed';
  static const kycAllowCameraView = 'KYC - Allow camera view';
  static const kycSelfieView = 'KYC - Selfie view';
  static const kycSuccessPageView = 'KYC - Success Page View';
  static const kycChangePhoneNumber = 'KYC - Change Phone Number';
  static const kycIdentityScreenView = 'KYC - Identity screen view';
  static const kycEnterPhoneNumber = 'KYC - Enter phone number';

  static const quickActionAssetView = 'Choose asset to buy';

  /// Buy Action
  static const previewBuy = 'Preview buy';
}
