import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

import '../simple_analytics.dart';
import 'helpers/hash_string.dart';
import 'models/event_type.dart';
import 'models/property_type.dart';
import 'models/user_type.dart';

final sAnalytics = SimpleAnalytics();

class SimpleAnalytics {
  factory SimpleAnalytics() => _instance;

  SimpleAnalytics._internal();

  static final SimpleAnalytics _instance = SimpleAnalytics._internal();

  final _analytics = Amplitude.getInstance();

  /// Run at the start of the app
  ///
  /// Provide:
  /// 1. environmentKey for Amplitude workspace
  /// 2. userEmail if user is already authenticated
  Future<void> init(String environmentKey, [String? userEmail]) async {
    await _analytics.init(environmentKey);

    if (userEmail != null) {
      await _analytics.setUserId(userEmail);
    }
  }

  void onboardingView() {
    _analytics.logEvent(EventType.onboardingView);
  }

  void signUpView() {
    _analytics.logEvent(EventType.signUpView);
  }

  Future<void> signUpSuccess(String userEmail) async {
    await _analytics.setUserId(userEmail);

    final identify = Identify()
      ..setOnce(UserType.signUpDate, '${DateTime.now()}')
      ..set(UserType.kycStatus, 'Unknown');

    await _analytics.identify(identify);
    await _analytics.logEvent(EventType.signUpSuccess);
  }

  void signUpFailure(String userEmail, String error) {
    _analytics.logEvent(
      EventType.signUpFailure,
      eventProperties: {
        PropertyType.error: error,
        PropertyType.email: userEmail,
        PropertyType.id: hashString(userEmail),
      },
    );
  }

  void emailVerificationView() {
    _analytics.logEvent(EventType.emailVerificationView);
  }

  void emailConfirmed() {
    _analytics.logEvent(EventType.emailConfirmed);
  }

  void loginView() {
    _analytics.logEvent(EventType.loginView);
  }

  Future<void> loginSuccess(String userEmail) async {
    await _analytics.setUserId(userEmail);
    await _analytics.logEvent(EventType.loginSuccess);
  }

  void loginFailure(String userEmail, String error) {
    _analytics.logEvent(
      EventType.loginFailure,
      eventProperties: {
        PropertyType.error: error,
        PropertyType.email: userEmail,
        PropertyType.id: hashString(userEmail),
      },
    );
  }

  /// Account
  void account() {
    _analytics.logEvent(
      EventType.account,
    );
  }

  void accountChangePassword() {
    _analytics.logEvent(
      EventType.accountChangePassword,
    );
  }

  void accountChangePasswordWarning() {
    _analytics.logEvent(
      EventType.accountChangePasswordWarning,
    );
  }

  void accountChangePasswordContinue() {
    _analytics.logEvent(
      EventType.accountChangePasswordContinue,
    );
  }

  void accountChangePasswordCancel() {
    _analytics.logEvent(
      EventType.accountChangePasswordCancel,
    );
  }

  void accountEnterOldPassword() {
    _analytics.logEvent(
      EventType.accountEnterOldPassword,
    );
  }

  void accountSetNewPassword() {
    _analytics.logEvent(
      EventType.accountSetNewPassword,
    );
  }

  void accountSuccessChange() {
    _analytics.logEvent(
      EventType.accountSuccessChange,
    );
  }

  void accountChangePhone() {
    _analytics.logEvent(
      EventType.accountChangePhone,
    );
  }

  void accountChangePhoneWarning() {
    _analytics.logEvent(
      EventType.accountChangePhoneWarning,
    );
  }

  void accountChangePhoneContinue() {
    _analytics.logEvent(
      EventType.accountChangePhoneContinue,
    );
  }

  void accountChangePhoneCancel() {
    _analytics.logEvent(
      EventType.accountChangePhoneCancel,
    );
  }

  void accountEnterNumber() {
    _analytics.logEvent(
      EventType.accountEnterNumber,
    );
  }

  void accountSuccessPhone() {
    _analytics.logEvent(
      EventType.accountSuccessPhone,
    );
  }

  /// Full name must be provided e.g. Bitcoin, and not BTC (ticker)
  void assetView(String assetName) {
    _analytics.logEvent(
      EventType.assetView,
      eventProperties: {
        PropertyType.assetName: assetName,
      },
    );
  }

  void earnProgramView(Source source) {
    _analytics.logEvent(
      EventType.earnProgramView,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void kycVerifyProfile(Source source, KycScope scope) {
    _analytics.logEvent(
      EventType.kycVerifyProfile,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
        PropertyType.kysScope: scope.name,
      },
    );
  }

  void changeCountryCode(String country) {
    _analytics.logEvent(
      EventType.changeCountryCode,
      eventProperties: {
        PropertyType.country: country,
      },
    );
  }

  void identityParametersChoosed(
    String countryName,
    String documentType,
  ) {
    _analytics.logEvent(
      EventType.identityParametersChoosed,
      eventProperties: {
        PropertyType.countryOfIssue: countryName,
        PropertyType.documentType: documentType,
      },
    );
  }

  void marketFilter(FilterMarketTabAction marketFilter) {
    _analytics.logEvent(
      EventType.marketFilters,
      eventProperties: {
        PropertyType.marketFilter: marketFilter.name,
      },
    );
  }

  void addToWatchlist(String assetName) {
    _analytics.logEvent(
      EventType.addToWatchlist,
      eventProperties: {
        PropertyType.assetName: assetName,
      },
    );
  }

  void clickMarketBanner(String campaignName, MarketBannerAction action) {
    _analytics.logEvent(
      EventType.clickMarketBanner,
      eventProperties: {
        PropertyType.campaignName: campaignName,
        PropertyType.action: action.name,
      },
    );
  }

  void rewardsScreenView(Source source) {
    _analytics.logEvent(
      EventType.rewardsScreenView,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void inviteFriendView(Source source) {
    _analytics.logEvent(
      EventType.inviteFriendView,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void buyView(Source source, String assetName) {
    _analytics.logEvent(
      EventType.buyView,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
        PropertyType.assetName: assetName,
      },
    );
  }

  void buySheetView() => _analytics.logEvent(EventType.buySheetView);

  void earnDetailsView(String assetName) {
    _analytics.logEvent(
      EventType.earnDetailsView,
      eventProperties: {
        PropertyType.assetName: assetName,
      },
    );
  }

  void walletAssetView(Source source, String assetName) {
    _analytics.logEvent(
      EventType.walletAssetView,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
        PropertyType.assetName: assetName,
      },
    );
  }

  void kycCameraAllowed() {
    _analytics.logEvent(
      EventType.kycCameraAllowed,
      eventProperties: {
        PropertyType.sourceScreen: KycScope.kycCameraAllowed.name,
      },
    );
  }

  void kycCameraNotAllowed() {
    _analytics.logEvent(
      EventType.kycCameraNotAllowed,
      eventProperties: {
        PropertyType.sourceScreen: KycScope.kycCameraNotAllowed.name,
      },
    );
  }

  void kycIdentityUploaded() {
    _analytics.logEvent(
      EventType.kycIdentityUploaded,
      eventProperties: {
        PropertyType.sourceScreen: KycScope.kycIdentityUploaded.name,
      },
    );
  }

  void kycIdentityUploadFailed(String error) {
    _analytics.logEvent(
      EventType.kycIdentityUploadFailed,
      eventProperties: {
        PropertyType.sourceScreen: KycScope.kycIdentityUploadFailed.name,
        PropertyType.error: error,
      },
    );
  }

  void kycSelfieUploaded() {
    _analytics.logEvent(
      EventType.kycSelfieUploaded,
      eventProperties: {
        PropertyType.sourceScreen: KycScope.kycIdentityUploaded.name,
      },
    );
  }

  void kycPhoneConfirmationView() {
    _analytics.logEvent(
      EventType.kycPhoneConfirmationView,
    );
  }

  void kycPhoneConfirmed() {
    _analytics.logEvent(
      EventType.kycPhoneConfirmed,
    );
  }

  void kycChangePhoneNumber() {
    _analytics.logEvent(
      EventType.kycChangePhoneNumber,
    );
  }

  void kycIdentityScreenView() {
    _analytics.logEvent(
      EventType.kycIdentityScreenView,
    );
  }

  void kycPhoneConfirmFailed(String error) {
    _analytics.logEvent(
      EventType.kycPhoneConfirmFailed,
      eventProperties: {
        PropertyType.kycPhoneConfirmFailed: error,
      },
    );
  }

  void kycEnterPhoneNumber() {
    _analytics.logEvent(
      EventType.kycEnterPhoneNumber,
    );
  }

  void kycAllowCameraView() {
    _analytics.logEvent(
      EventType.kycAllowCameraView,
    );
  }

  void kycSelfieView() {
    _analytics.logEvent(
      EventType.kycSelfieView,
    );
  }

  void kycSuccessPageView() {
    _analytics.logEvent(
      EventType.kycSuccessPageView,
    );
  }

  void kycAllowCamera() {
    _analytics.logEvent(
      EventType.kycAllowCamera,
    );
  }

  void kycGiveCameraPermission() {
    _analytics.logEvent(
      EventType.kycGiveCameraPermission,
    );
  }

  void kycTapOnGoToSettings() {
    _analytics.logEvent(
      EventType.kycTapOnGoToSettings,
    );
  }

  void kycTapOnEnableCamera() {
    _analytics.logEvent(
      EventType.kycTapOnEnableCamera,
    );
  }

  /// Call when user makes logout.
  /// It will clean unique userId and will generate deviceId,
  /// so the user will appear as a brand new one.
  Future<void> logout() async {
    await _analytics.logEvent(EventType.logout);
    await _analytics.setUserId(null);
  }

  /// Sell
  void sellClick({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.sellClick,
      eventProperties: {
        PropertyType.sellSource: source,
      },
    );
  }

  void sellChooseAsset() {
    _analytics.logEvent(EventType.sellChooseAsset);
  }

  void sellChooseAssetClose() {
    _analytics.logEvent(EventType.sellChooseAssetClose);
  }

  void sellChooseDestination() {
    _analytics.logEvent(EventType.sellChooseDestination);
  }

  void sellForView() {
    _analytics.logEvent(EventType.sellForView);
  }

  void sellCloseFor() {
    _analytics.logEvent(EventType.sellCloseFor);
  }

  void sellTapPreview({
    required String sourceCurrency,
    required String sourceAmount,
    required String destinationCurrency,
    required String destinationAmount,
    required String sellPercentage,
  }) {
    _analytics.logEvent(
      EventType.sellTapPreview,
      eventProperties: {
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.destinationAmount: destinationAmount,
        PropertyType.sellPercentage: sellPercentage,
      },
    );
  }

  void sellConfirm({
    required String sourceCurrency,
    required String sourceAmount,
    required String destinationCurrency,
    required String destinationAmount,
  }) {
    _analytics.logEvent(
      EventType.sellConfirm,
      eventProperties: {
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.destinationAmount: destinationAmount,
      },
    );
  }

  void sellSuccess() {
    _analytics.logEvent(EventType.sellSuccess);
  }

  /// Sell
  void convertClick({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.convertClick,
      eventProperties: {
        PropertyType.sellSource: source,
      },
    );
  }

  void convertPageView() {
    _analytics.logEvent(EventType.convertPageView);
  }

  void convertSuccess() {
    _analytics.logEvent(EventType.convertSuccess);
  }

  void convertTapPreview({
    required String sourceCurrency,
    required String sourceAmount,
    required String destinationCurrency,
    required String destinationAmount,
    required String sellPercentage,
  }) {
    _analytics.logEvent(
      EventType.convertTapPreview,
      eventProperties: {
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.destinationAmount: destinationAmount,
        PropertyType.sellPercentage: sellPercentage,
      },
    );
  }

  void convertConfirm({
    required String sourceCurrency,
    required String sourceAmount,
    required String destinationCurrency,
    required String destinationAmount,
  }) {
    _analytics.logEvent(
      EventType.convertConfirm,
      eventProperties: {
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.destinationAmount: destinationAmount,
      },
    );
  }

  /// Buy
  void tapPreviewBuy({
    required String assetName,
    required String paymentMethod,
    required String amount,
    required RecurringFrequency frequency,
    String? preset,
  }) {
    _analytics.logEvent(
      EventType.tapPreviewBuy,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.amount: amount,
        PropertyType.frequency: frequency.name,
        PropertyType.preset: preset,
      },
    );
  }

  void previewBuyView({
    required String assetName,
    required String paymentMethod,
    required String amount,
    required RecurringFrequency frequency,
  }) {
    _analytics.logEvent(
      EventType.previewBuyView,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.amount: amount,
        PropertyType.frequency: frequency.name,
      },
    );
  }

  void tapConfirmBuy({
    required String assetName,
    required String paymentMethod,
    required String amount,
    required RecurringFrequency frequency,
  }) {
    _analytics.logEvent(
      EventType.tapConfirmBuy,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.amount: amount,
        PropertyType.frequency: frequency.name,
      },
    );
  }

  void simplexView(String url) {
    _analytics.logEvent(
      EventType.simplexView,
      eventProperties: {
        PropertyType.url: url,
      },
    );
  }

  void simplexSucsessView(String url) {
    _analytics.logEvent(EventType.simplexSucsessView);
  }

  void simplexFailureView(String url) {
    _analytics.logEvent(EventType.simplexFailureView);
  }

  /// Circle
  void circleChooseMethod() {
    _analytics.logEvent(EventType.circleChooseMethod);
  }

  void circlePayFromView() {
    _analytics.logEvent(EventType.circlePayFromView);
  }

  void circleTapAddCard() {
    _analytics.logEvent(EventType.circleTapAddCard);
  }

  void circleContinueDetails() {
    _analytics.logEvent(EventType.circleContinueDetails);
  }

  void circleContinueAddress() {
    _analytics.logEvent(EventType.circleContinueAddress);
  }

  void circleCVVView() {
    _analytics.logEvent(EventType.circleCVVView);
  }

  void circleCloseCVV() {
    _analytics.logEvent(EventType.circleCloseCVV);
  }

  void circleRedirect() {
    _analytics.logEvent(
      EventType.circleRedirect,
    );
  }

  void circleSuccess({
    required String asset,
    required String amount,
    required RecurringFrequency frequency,
  }) {
    _analytics.logEvent(
      EventType.circleSuccess,
      eventProperties: {
        PropertyType.assetName: asset,
        PropertyType.frequency: frequency.name,
        PropertyType.amount: amount,
      },
    );
  }

  void circleFailed() {
    _analytics.logEvent(EventType.circleFailed);
  }

  void circleAdd() {
    _analytics.logEvent(EventType.circleAdd);
  }

  void circleCancel() {
    _analytics.logEvent(EventType.circleCancel);
  }

  /// Quick actions
  void tapOnBuy(Source source) {
    _analytics.logEvent(
      EventType.tapOnBuy,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void tapOnBuyFromCard(Source source) {
    _analytics.logEvent(
      EventType.tapOnBuyFromCard,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  /// Receive
  void receiveClick({required String source}) {
    _analytics.logEvent(
      EventType.receiveClick,
      eventProperties: {
        PropertyType.sourceReceive: source,
      },
    );
  }

  void receiveChooseAsset() {
    _analytics.logEvent(EventType.receiveChooseAsset);
  }

  void receiveChooseAssetClose() {
    _analytics.logEvent(EventType.receiveChooseAssetClose);
  }

  void receiveAssetView({required String asset}) {
    _analytics.logEvent(
      EventType.receiveAssetView,
      eventProperties: {
        PropertyType.assetReceive: asset,
      },
    );
  }

  void receiveCopy({required String asset}) {
    _analytics.logEvent(
      EventType.receiveCopy,
      eventProperties: {
        PropertyType.assetReceive: asset,
      },
    );
  }

  void receiveShare({required String asset}) {
    _analytics.logEvent(
      EventType.receiveShare,
      eventProperties: {
        PropertyType.assetReceive: asset,
      },
    );
  }

  /// Send
  void sendClick({required String source}) {
    _analytics.logEvent(
      EventType.sendClick,
      eventProperties: {
        PropertyType.sourceReceive: source,
      },
    );
  }

  void sendChooseAsset() {
    _analytics.logEvent(EventType.sendChooseAsset);
  }

  void sendChooseAssetClose() {
    _analytics.logEvent(EventType.sendChooseAssetClose);
  }

  void sendToView() {
    _analytics.logEvent(EventType.sendToView);
  }

  void sendToViewClose() {
    _analytics.logEvent(EventType.sendToViewClose);
  }

  void sendChoosePhone() {
    _analytics.logEvent(EventType.sendChoosePhone);
  }

  void sendChoosePhoneClose() {
    _analytics.logEvent(EventType.sendChoosePhoneClose);
  }

  void sendContinuePhone() {
    _analytics.logEvent(EventType.sendContinuePhone);
  }

  void sendContinueAddress() {
    _analytics.logEvent(EventType.sendContinueAddress);
  }

  void sendViews() {
    _analytics.logEvent(EventType.sendViews);
  }

  void sendTapPreview({
    required String currency,
    required String amount,
    required String type,
    required String percentage,
  }) {
    _analytics.logEvent(
      EventType.sendTapPreview,
      eventProperties: {
        PropertyType.percentageReceive: percentage,
        PropertyType.amount: amount,
        PropertyType.currency: currency,
        PropertyType.sendType: type,
      },
    );
  }

  void sendConfirm({
    required String currency,
    required String amount,
    required String type,
  }) {
    _analytics.logEvent(
      EventType.sendConfirm,
      eventProperties: {
        PropertyType.amount: amount,
        PropertyType.currency: currency,
        PropertyType.sendType: type,
      },
    );
  }

  void sendSuccess({
    required String type,
  }) {
    _analytics.logEvent(
      EventType.sendSuccess,
      eventProperties: {
        PropertyType.sendType: type,
      },
    );
  }

  void sendConfirmSend() {
    _analytics.logEvent(EventType.sendConfirmSend);
  }

  void sendNotifyRecipient() {
    _analytics.logEvent(
      EventType.sendNotifyRecipient,
    );
  }

  void sendTapOnSendMessage() {
    _analytics.logEvent(
      EventType.sendTapOnSendMessage,
    );
  }

  void sendTapOnSendLater() {
    _analytics.logEvent(
      EventType.sendTapOnSendLater,
    );
  }

  // [START] Recurring buy ->
  // Possible source values for "Setup recurring buy" sheet:
  // 1. Wallet details
  // 2. Asset screen on the market
  // 3. Success screen
  void setupRecurringBuyView(String assetName, Source source) {
    _analytics.logEvent(
      EventType.setupRecurringBuyView,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void pickRecurringBuyFrequency({
    required String assetName,
    required RecurringFrequency frequency,
    required Source source,
  }) {
    _analytics.logEvent(
      EventType.pickRecurringBuyFrequency,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.frequency: frequency.name,
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void closeRecurringBuySheet(String assetName, Source source) {
    _analytics.logEvent(
      EventType.closeRecurringBuySheet,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void recurringBuyView() => _analytics.logEvent(EventType.recurringBuyView);

  void tapManageButton({
    required String assetName,
    required RecurringFrequency frequency,
    required String amount,
  }) {
    _analytics.logEvent(
      EventType.tapManageButton,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.frequency: frequency.name,
        PropertyType.amount: amount,
      },
    );
  }

  void recurringBuyDeletionSheetView({
    required String assetName,
    required RecurringFrequency frequency,
    required String amount,
  }) {
    _analytics.logEvent(
      EventType.recurringBuyDeletionSheetView,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.frequency: frequency.name,
        PropertyType.amount: amount,
      },
    );
  }

  void cancelRecurringBuyDeletion({
    required String assetName,
    required RecurringFrequency frequency,
    required String amount,
  }) {
    _analytics.logEvent(
      EventType.cancelRecurringBuyDeletion,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.frequency: frequency.name,
        PropertyType.amount: amount,
      },
    );
  }

  void deleteRecurringBuy({
    required String assetName,
    required RecurringFrequency frequency,
    required String amount,
  }) {
    _analytics.logEvent(
      EventType.deleteRecurringBuy,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.frequency: frequency.name,
        PropertyType.amount: amount,
      },
    );
  }

  void pauseRecurringBuy({
    required String assetName,
    required RecurringFrequency frequency,
    required String amount,
  }) {
    _analytics.logEvent(
      EventType.pauseRecurringBuy,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.frequency: frequency.name,
        PropertyType.amount: amount,
      },
    );
  }

  void startRecurringBuy({
    required String assetName,
    required RecurringFrequency frequency,
    required String amount,
  }) {
    _analytics.logEvent(
      EventType.startRecurringBuy,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.frequency: frequency.name,
        PropertyType.amount: amount,
      },
    );
  }

  // <- Recurring buy [END]

  /// Earn

  void earnClickInfoButton() {
    _analytics.logEvent(
      EventType.earnClickInfoButton,
    );
  }

  void earnOnBoardingView() {
    _analytics.logEvent(
      EventType.earnOnBoardingView,
    );
  }

  void earnClickMore() {
    _analytics.logEvent(
      EventType.earnClickMore,
    );
  }

  void earnCloseOnboarding() {
    _analytics.logEvent(
      EventType.earnCloseOnboarding,
    );
  }

  void earnTapAvailable({
    required String assetName,
  }) {
    _analytics.logEvent(
      EventType.earnTapAvailable,
      eventProperties: {
        PropertyType.asset: assetName,
      },
    );
  }

  void earnAvailableView({
    required String assetName,
  }) {
    _analytics.logEvent(
      EventType.earnAvailableView,
      eventProperties: {
        PropertyType.asset: assetName,
      },
    );
  }

  void earnSelectOffer({
    required String assetName,
    required String offerType,
  }) {
    _analytics.logEvent(
      EventType.earnSelectOffer,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.offerType: offerType,
      },
    );
  }

  void earnProgressBar({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.earnProgressBar,
      eventProperties: {
        PropertyType.source: source,
      },
    );
  }

  void earnCalculationView({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.earnCalculationView,
      eventProperties: {
        PropertyType.source: source,
      },
    );
  }

  void earnPreview({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String percentage,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnPreview,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.percentage: percentage,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnConfirm({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnConfirm,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnSuccessPage() {
    _analytics.logEvent(
      EventType.earnSuccessPage,
    );
  }

  void earnTapActive({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnTapActive,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnActiveSheetView({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnActiveSheetView,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnCloseActiveSheet({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnCloseActiveSheet,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnTapManage({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnTapManage,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnManageView({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnManageView,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnCloseManage({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnCloseManage,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnClickTopUp({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnClickTopUp,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnPreviewTopUp({
    required String assetName,
    required String amount,
    required String offerId,
    required String apy,
    required String term,
    required String percentage,
  }) {
    _analytics.logEvent(
      EventType.earnPreviewTopUp,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.topUpAmount: amount,
        PropertyType.topUpAPY: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
        PropertyType.percentage: percentage,
      },
    );
  }

  void earnConfirmTopUp({
    required String assetName,
    required String amount,
    required String offerId,
    required String apy,
    required String term,
  }) {
    _analytics.logEvent(
      EventType.earnConfirmTopUp,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.topUpAmount: amount,
        PropertyType.topUpAPY: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnSuccessTopUp({
    required String assetName,
    required String amount,
    required String offerId,
    required String apy,
    required String term,
  }) {
    _analytics.logEvent(
      EventType.earnSuccessTopUp,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.topUpAmount: amount,
        PropertyType.topUpAPY: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnClickReclaim({
    required String assetName,
    required String amount,
    required String apy,
    required String term,
    required String offerId,
  }) {
    _analytics.logEvent(
      EventType.earnClickReclaim,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.amount: amount,
        PropertyType.apy: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnPreviewReclaim({
    required String assetName,
    required String amount,
    required String offerId,
    required String apy,
    required String term,
    required String percentage,
  }) {
    _analytics.logEvent(
      EventType.earnPreviewReclaim,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.reclaimAmount: amount,
        PropertyType.reclaimAPY: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
        PropertyType.percentage: percentage,
      },
    );
  }

  void earnConfirmReclaim({
    required String assetName,
    required String amount,
    required String offerId,
    required String apy,
    required String term,
  }) {
    _analytics.logEvent(
      EventType.earnConfirmReclaim,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.reclaimAmount: amount,
        PropertyType.reclaimAPY: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void earnSuccessReclaim({
    required String assetName,
    required String amount,
    required String offerId,
    required String apy,
    required String term,
  }) {
    _analytics.logEvent(
      EventType.earnSuccessReclaim,
      eventProperties: {
        PropertyType.asset: assetName,
        PropertyType.reclaimAmount: amount,
        PropertyType.reclaimAPY: apy,
        PropertyType.term: term,
        PropertyType.offerId: offerId,
      },
    );
  }

  void uploadIdentityDocument() {
    _analytics.logEvent(
      EventType.kycScanDoc,
    );
  }

  /// Banner account
  void bannerClick({
    required String bannerName,
  }) {
    _analytics.logEvent(
      EventType.accountBannerClick,
      eventProperties: {
        PropertyType.bannerName: bannerName,
      },
    );
  }

  void bannerClose({
    required String bannerName,
  }) {
    _analytics.logEvent(
      EventType.accountBannerClose,
      eventProperties: {
        PropertyType.bannerName: bannerName,
      },
    );
  }

  /// Push notification
  void openPushNotification({
    required String campaignId,
  }) {
    _analytics.logEvent(
      EventType.clickNotification,
      eventProperties: {
        PropertyType.campaignId: campaignId,
      },
    );
  }

  /// Time tracking
  void timeStartMarket({
    required String time,
  }) {
    _analytics.logEvent(
      EventType.timeStartMarket,
      eventProperties: {
        PropertyType.time: time,
      },
    );
  }

  void timeStartInitFinished({
    required String time,
  }) {
    _analytics.logEvent(
      EventType.timeStartInitFinished,
      eventProperties: {
        PropertyType.time: time,
      },
    );
  }

  void timeStartConfig({
    required String time,
  }) {
    _analytics.logEvent(
      EventType.timeStartConfig,
      eventProperties: {
        PropertyType.time: time,
      },
    );
  }

  void timeSignalRCheckIF({
    required String time,
  }) {
    _analytics.logEvent(
      EventType.timeSignalRCheckIF,
      eventProperties: {
        PropertyType.time: time,
      },
    );
  }

  void timeSignalRReceiveIF({
    required String time,
  }) {
    _analytics.logEvent(
      EventType.timeSignalRReceiveIF,
      eventProperties: {
        PropertyType.time: time,
      },
    );
  }

  void initFinishedOnMarket({
    required String isFinished,
  }) {
    _analytics.logEvent(
      EventType.initFinishedOnMarket,
      eventProperties: {
        PropertyType.isLoaded: isFinished,
      },
    );
  }

  void initFinished() {
    _analytics.logEvent(
      EventType.initFinished,
    );
  }

  void remoteConfig() {
    _analytics.logEvent(
      EventType.remoteConfig,
    );
  }

  void remoteConfigError() {
    _analytics.logEvent(
      EventType.remoteConfigError,
    );
  }

  /// Payment methods
  void paymentTap() {
    _analytics.logEvent(
      EventType.paymentTap,
    );
  }

  void paymentView() {
    _analytics.logEvent(
      EventType.paymentView,
    );
  }

  void paymentAdd() {
    _analytics.logEvent(
      EventType.paymentAdd,
    );
  }

  void paymentDetailsView({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.paymentDetailsView,
      eventProperties: {
        PropertyType.source: source,
      },
    );
  }

  void paymentDetailsContinue({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.paymentDetailsContinue,
      eventProperties: {
        PropertyType.source: source,
      },
    );
  }

  void paymentBillingView({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.paymentBillingView,
      eventProperties: {
        PropertyType.source: source,
      },
    );
  }

  void paymentBillingContinue({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.paymentBillingContinue,
      eventProperties: {
        PropertyType.source: source,
      },
    );
  }
}
