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

  /// Quick actions bottom sheet
  static const buySheetView = 'Buy sheet view';
  static const sellSheetView = 'Sell sheet view';
  static const convertSheetView = 'Convert sheet view';
  static const depositSheetView = 'Deposit sheet view';
  static const receiveSheetView = 'Receive sheet view';
  static const sendSheetView = 'Send sheet view';

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

  /// Sell
  static const sellClick = 'Click on Sell';
  static const sellChooseAsset = 'Choose asset to sell sheet view';
  static const sellChooseAssetClose = 'Close Choose asset to sell sheet';
  static const sellChooseDestination = 'Tap on Choose destination';
  static const sellForView = 'For sheet view';
  static const sellCloseFor = 'Close For sheet';
  static const sellTapPreview = 'Tap on Preview Sell';
  static const sellConfirm = 'Confirm Sell';
  static const sellSuccess = 'Success Page - Sell';

  /// Convert
  static const convertClick = 'Tap on Convert';
  static const convertPageView = 'Convert Page View';
  static const convertTapPreview = 'Tap on Preview Convert';
  static const convertConfirm = 'Tap on Confirm Convert Button';
  static const convertSuccess = 'Success Page - Convert';

  /// Buy screen
  static const tapPreviewBuy = 'Tap preview buy';
  static const previewBuyView = 'Preview buy view';
  static const simplexView = 'Simplex view';
  static const simplexSucsessView = 'Simplex success view';
  static const simplexFailureView = 'Simplex failure view';

  /// Quick actions
  /// User taps on "Buy" in Quick Actions
  static const tapOnBuy = 'Tap on buy';

  /// User taps on "Buy from card" in Quick Actions
  static const tapOnBuyFromCard = 'Tap on buy from card';

  // [START] Recurring buy ->
  static const setupRecurringBuyView = '"Setup recurring buy" sheet view';
  static const pickRecurringBuyFrequency =
      'Pick frequency on "Setup recurring buy" sheet';
  static const closeRecurringBuySheet = 'Close "Setup recurring buy" sheet';
  // "Reccuring buy" screen displayed after click on the tab
  // called "Recurring buy" in Account
  static const recurringBuyView = 'Recurring buy view';
  // User clicks on the button "Manage" in the recurring buy order
  static const tapManageButton = 'Tap "Manage" button';
  static const recurringBuyDeletionSheetView =
      'Recurring buy deletion sheet view';
  static const cancelRecurringBuyDeletion = 'Cancel recurring buy deletion';
  static const deleteRecurringBuy = 'Delete recurring buy';
  static const pauseRecurringBuy = 'Pause recurring buy';
  static const startRecurringBuy = 'Start recurring buy';
  // <- Recurring buy [END]
}
