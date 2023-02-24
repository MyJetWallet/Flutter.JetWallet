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

  /// Account page
  static const account = 'Click on Profile Details tab';
  static const accountChangePassword = 'Click on Change Password ';
  static const accountChangePasswordWarning =
      'Change password warning pop-up view';
  static const accountChangePasswordContinue = 'Continue Changing Password';
  static const accountChangePasswordCancel = 'Cancel Changing Password';
  static const accountEnterOldPassword = 'Continue after entering old password';
  static const accountSetNewPassword = 'Set new password';
  static const accountSuccessChange = 'Success page - Password was changed';
  static const accountChangePhone = 'Click on Change Phone Number';
  static const accountChangePhoneWarning =
      'Change phone number warning pop-up view';
  static const accountChangePhoneContinue = 'Continue Changing Phone Number';
  static const accountChangePhoneCancel = 'Cancel Changing Phone Number';
  static const accountEnterNumber = 'Continue after entering new phone number';
  static const accountSuccessPhone = 'Success page - Phone number was changed';

  /// User visits Asset details screen with Chart/About....
  static const assetView = 'Asset View';

  /// User visits Earn program screen (all assets + APY)
  static const earnProgramView = 'Earn program view';

  /// Logout action
  static const logout = 'Logout';

  /// Places where we call kyc popup
  static const kycVerifyProfile = 'KYC - Verify your profile';

  /// Change country code, send country name
  static const changeCountryCode = 'KYC - Change country code';

  /// Choose country name and document type in kyc
  static const identityParametersChoosed = 'KYC - Identity parameters choosed';

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
  static const convertView = 'Convert view';
  static const receiveView = 'Receive view';
  static const sendView = 'Send view';

  /// Quick actions bottom sheet
  static const buySheetView = 'Buy sheet view';
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
  static const kycScanDoc = 'KYC - Upload identity document view';
  static const kycAllowCamera = 'KYC - Allow camera access page view';
  static const kycGiveCameraPermission =
      'KYC - Give Permission to allow the use of camera page view';
  static const kycTapOnGoToSettings = 'KYC - Tap on button Go to Settings';
  static const kycTapOnEnableCamera = 'KYC - Tap on Enable Camera button';

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

  /// Receive
  static const receiveClick = 'Tap on Receive';
  static const receiveChooseAsset = 'Choose asset to receive sheet view';
  static const receiveChooseAssetClose = 'Close Choose asset to receive sheet';
  static const receiveAssetView = 'Receive Asset Sheet View';
  static const receiveCopy = 'Copy wallet adderss';
  static const receiveShare = 'Tap on Share button';

  /// Send
  static const sendClick = 'Tap on Send';
  static const sendChooseAsset = 'Choose asset to send sheet view';
  static const sendChooseAssetClose = 'Close Choose asset to send sheet';
  static const sendToView = 'Send to sheet view';
  static const sendToViewClose = 'Close Send to sheet view';
  static const sendChoosePhone = 'Choose Phone number sheet view';
  static const sendChoosePhoneClose = 'Close Choose Phone Number sheet';
  static const sendContinuePhone = 'Continue with phone number';
  static const sendContinueAddress = 'Continue with wallet address';
  static const sendViews = 'Send View';
  static const sendTapPreview = 'Tap on Preview Send';
  static const sendConfirm = 'Tap on Confirm Send';
  static const sendSuccess = 'Success Page - Send';
  static const sendConfirmSend = 'Phone 2FA Confirmation View';
  static const sendNotifyRecipient =
      "Notify the recepient about sent' page view'";
  static const sendTapOnSendMessage = "Tap on 'Send a Message'";
  static const sendTapOnSendLater = "Tap on 'Later'";

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

  /// Banners account
  static const accountBannerClick = 'Account Banner Click.';
  static const accountBannerClose = 'Close Account Banner.';

  /// Earn
  static const earnClickInfoButton = 'Click on Info button - onboarding';
  static const earnOnBoardingView = 'Onboarding sheet view';
  static const earnClickMore = "Click on 'Learn more' - onboarding";
  static const earnCloseOnboarding = "Close 'Onboarding' sheet";
  static const earnTapAvailable = 'Tap on Asset available for Earn';
  static const earnAvailableView = 'Offers per asset sheet view';
  static const earnSelectOffer = 'Select offer';
  static const earnProgressBar = 'Tap on progress bar(%)';
  static const earnCalculationView = 'Calculation plan sheet view';
  static const earnPreview = 'Preview Earn';
  static const earnConfirm = 'Tap on Confirm Earn button';
  static const earnSuccessPage = 'Earn Success Page View';
  static const earnTapActive = 'Tap on Active Subscription';
  static const earnActiveSheetView = 'Active Subscription Sheet View';
  static const earnCloseActiveSheet = 'Close Active Subscription Sheet View';
  static const earnTapManage = 'Tap on Manage button';
  static const earnManageView = 'Manage Sheet View';
  static const earnCloseManage = 'Close Manage Sheet View';
  static const earnClickTopUp = 'Click on Top up Button';
  static const earnPreviewTopUp = 'Preview Top up';
  static const earnConfirmTopUp = 'Confirm Top up';
  static const earnSuccessTopUp = 'Success Top up page';
  static const earnClickReclaim = 'Click on Reclaim Earn Button';
  static const earnPreviewReclaim = 'Preview Reclaim Earn';
  static const earnConfirmReclaim = 'Confirm Reclaim Earn';
  static const earnSuccessReclaim = 'Success Reclaim Earn Page';

  /// Push notification
  static const clickNotification = 'Click on push notification';

  /// Time tracking
  static const timeStartMarket = 'Time: Start -> Market';
  static const timeStartInitFinished = 'Time: Start -> initFinished';
  static const timeStartConfig = 'Time: Start -> config';
  static const timeSignalRCheckIF = 'Time: signalR start -> check initFinished';
  static const timeSignalRReceiveIF =
      'Time: signalR start -> receive initFinished';
  static const initFinishedOnMarket = 'initFinished received on market screen';
  static const initFinished = 'initFinished received';
  static const remoteConfig = 'remoteConfig received';
  static const remoteConfigError = 'remoteConfig error';


  /// NFT
  static const iHavePromoCode = 'Tap on button - I have a promocode';
  static const enterPromoCode = 'Enter promo code sheet view';
  static const closePromoCode = 'Close Enter promo code sheet';
  static const tapOnContinuePromoCode =
      'Tap on Continue with promo code button';

  static const nftMarketOpen = 'Tap on NFT button on Market';
  static const nftMarketTapCollection = 'Tap on NFT Collection';
  static const nftMarketTapFilter = 'Tap on NFT Filter';
  static const nftMarketFilterShowed = "Filter sheet 'Show' is displayed";
  static const nftMarketFilterClose = "Close filter  sheet 'Show'";

  static const nftCollectionView = 'Collection Screen View';
  static const nftCollectionTapSort = "Tap on 'Sort' NFT button";
  static const nftCollectionSortView = 'Sort by sheet view';
  static const nftCollectionSortClose = "Close sheet 'Sort by'";
  static const nftCollectionSortApply = 'Sort NFT Filter Applied';
  static const nftCollectionTapHide = 'Tap on Hide NFT button';
  static const nftCollectionTapShow = 'Tap on Show NFT button';

  static const nftObjectTap = 'Tap on NFT Object';
  static const nftObjectView = 'NFT Object sсreen view';
  static const nftObjectTapBack = 'Tap on Back <- button';
  static const nftObjectTapCollection = 'Tap on Collection link';
  static const nftObjectTapCurrency = 'Tap on Currency wallet(NFT)';
  static const nftObjectTapBuy = 'Tap on Buy NFT button';
  static const nftObjectNotEnoughAsset = 'Not enough Asset Name sheet view';
  static const nftObjectTapGetAsset = 'Tap on Get Asset Name button';
  static const nftObjectCloseNotEnough = 'Close sheet Not enough Asset Name';
  static const nftObjectTapPicture = 'Tap on NFT picture';
  static const nftObjectPictureView = 'NFT picture is displayed';
  static const nftObjectPictureClose = 'Close NFT picture';
  static const nftObjectTapShare = 'Tap on Share NFT sign';
  static const nftObjectShareView = 'Share NFT sheet view';
  static const nftObjectTapCopy = 'Tap on Copy Link sign(NFT)';
  static const nftObjectTapShareTap = 'Tap on Share button(NFT)';
  static const nftObjectShareClose = 'Close Share NFT sheet';

  static const nftPurchaseConfirmView = 'Confirm Buy NFT screen view';
  static const nftPurchaseTapBack = 'Tap on Back to NFT Object button';
  static const nftPurchaseConfirmTap = 'Tap on Confirm Buy NFT button';
  static const nftPurchaseProcessing = 'Processing NFT Buy screen view';
  static const nftPurchaseSuccess = 'Success NFT Buy screen view';
  static const nftPurchaseDisplayed =
      'Bought NFT Object is displayed in Portfolio';

  static const nftPortfolioTapNft = 'Tap on Portfolio NFT Filter';
  static const nftPortfolioNFTView = 'NFT Portfolio screen view';
  static const nftPortfolioHistory = 'Tap on NFT History button';
  static const nftPortfolioHistoryView = 'NFT History screen view';
  static const nftPortfolioBuy = 'Tap on Buy NFT(Portfolio) button';
  static const nftPortfolioReceive = 'Tap on Receive NFT(Portfolio) button';

  static const nftWalletTapObject = 'Tap on bought NFT Object';
  static const nftWalletObjectView = 'Bought NFT Object screen view';
  static const nftWalletActionTap = 'Tap on Action(bought NFT screen)';
  static const nftWalletActionView = 'NFT Action sheet view';
  static const nftWalletStatsTap = 'Tap on My Stats';
  static const nftWalletHistory = 'NFT Object history is displayed';
  static const nftWalletTapHistoryObject = 'Tap on NFT Object history record';
  static const nftWalletHistoryObjectView = 'NFT Object history record view';
  static const nftWalletTapCollection = 'Tap on bought NFT Collection';
  static const nftWalletCollectionView =
      'List of bought objects from collection is displayed';
  static const nftWalletObjectFull = 'Open bought NFT Object in full size';

  static const nftSellTap = 'Tap on Sell NFT button';
  static const nftSellPreview = 'Preview Sell NFT screen view';
  static const nftSellPreviewTap = 'Tap on Preview Sell NFT button';
  static const nftSellConfirmView = 'Confirm Sell NFT screen view';
  static const nftSellConfirmTap = 'Tap on Confirm Sell NFT button';
  static const nftSellProcessing = 'Processing Sell NFT sreen view';
  static const nftSellSuccess = 'Success Sell NFT screen view';
  static const nftSellCancelTap = 'Tap on Cancel Selling button';
  static const nftSellPreviewBack = 'Go Back on Preview Sell NFT screen';
  static const nftSellConfirmBack = 'Go Back on Confirm Sell NFT screen';

  static const nftSendTap = 'Tap on Send NFT button';
  static const nftSendView = 'Send NFT screen view';
  static const nftSendBack = 'Go Back to NFT Object';
  static const nftSendContinue = 'User taps on Continue Send NFT button';
  static const nftSendConfirmView = 'Confirm Send NFT Screen View';
  static const nftSendConfirmBack = 'Go Back to Send NFT screen';
  static const nftSendConfirmTap = 'Tap on Confirm Send NFT button';
  static const nftSendProcessing = 'Processing Send NFT screen view';
  static const nftSendSuccess = 'Success Send NFT screen view';

  static const nftReceiveTap = 'Tap on Receive NFT button';
  static const nftReceiveShareTap = 'Tap on Share NFT Receive address';
  static const nftReceiveCopyTap = 'Tap on Copy Receive NFT address button';
  static const nftReceiveBack = 'Go Back from Receive NFT screen';

  /// New buy flow
  static const newBuyZeroScreenView = '‘My assets - Zero balance’ screen view';
  static const newBuyTapBuy = 'Tap on the ‘Buy/Buy Crypto’ button';
  static const newBuyChooseAssetView = '‘Choose asset’ screen view';
  static const newBuyNoSavedCard =
      '‘Payment method - No Saved Cards’ screen view';
  static const newBuyTapAddCard = 'Tap on the ‘Add a Card’ button';
  static const newBuyEnterCardDetailsView = '‘Enter card details’ screen view ';
  static const newBuyTapSaveCard = 'Tap on the ‘Save card’ button';
  static const newBuyTapCardContinue =
      'Tap on the ‘Continue’ with Card Details button';
  static const newBuyBuyAssetView = '‘Buy Asset’ screen view';
  static const newBuyErrorLimit = 'Error - Buy Limit Exceeded';
  static const newBuyTapCardLimits = 'Tap on the  ‘Card - limits’ button';
  static const newBuyCardLimitsView = '‘Card Limits’ screen view';
  static const newBuyTapCurrency = 'Tap on the ‘Currency’ button';
  static const newBuyChooseCurrencyView = '‘Choose currency’ screen view';
  static const newBuyTapContinue =
      'Tap on the button ‘Continue’ with Buy Asset';
  static const newBuyOrderSummaryView = '‘Order summary‘ screen view';
  static const newBuyTapAgreement =
      'Tap to agree to the T&C and Privacy Policy';
  static const newBuyTapConfirm = 'Tap on the button ‘Confirm’ Order Summary ';
  static const newBuyTapPaymentFee = 'Tap on the  button ‘Payment Fee - info’';
  static const newBuyFeeView = '‘Transaction fee’ screen view';
  static const newBuyEnterCvvView = '‘Enter CVV’ screen view';
  static const newBuyProcessingView = '‘Processing Buy’ screen view';
  static const newBuyTapCloseProcessing =
      'Tap on the button ‘Close’ Processing screen ';
  static const newBuySuccessView = '‘Success Buy’ screen view';
  static const newBuyFailedView = '‘Failed Buy’ screen view';
  static const newBuyTapEdit = 'Tap on the button ‘Edit’ payment methods';
  static const newBuyTapDelete = 'Tap on the button ‘Delete’ card';
  static const newBuyDeleteView = '‘Delete card?’ screen view';
  static const newBuyTapYesDelete = 'Tap on the button ‘Yes, delete the card’';
  static const newBuyTapCancelDelete =
      'Tap on the button ‘Cancel’ deleting the card';
}
