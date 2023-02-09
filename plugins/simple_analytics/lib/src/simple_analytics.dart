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

  bool isTechAcc = false;
  bool newBuyZeroScreenViewSent = false;

  /// Run at the start of the app
  ///
  /// Provide:
  /// 1. environmentKey for Amplitude workspace
  /// 2. userEmail if user is already authenticated
  Future<void> init(String environmentKey, bool techAcc,
      [String? userEmail]) async {
    await _analytics.init(environmentKey);

    if (userEmail != null) {
      await _analytics.setUserId(userEmail);
    }

    isTechAcc = techAcc;
  }

  void updateTechAccValue(bool techAcc) {
    isTechAcc = techAcc;
  }

  void onboardingView() {
    _analytics.logEvent(
      EventType.onboardingView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void signUpView() {
    _analytics.logEvent(
      EventType.signUpView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  Future<void> signUpSuccess(String userEmail) async {
    await _analytics.setUserId(userEmail);

    final identify = Identify()
      ..setOnce(UserType.signUpDate, '${DateTime.now()}')
      ..set(UserType.kycStatus, 'Unknown');

    await _analytics.identify(identify);
    await _analytics.logEvent(
      EventType.signUpSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void signUpFailure(String userEmail, String error) {
    _analytics.logEvent(
      EventType.signUpFailure,
      eventProperties: {
        PropertyType.error: error,
        PropertyType.email: userEmail,
        PropertyType.id: hashString(userEmail),
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void emailVerificationView() {
    _analytics.logEvent(
      EventType.emailVerificationView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void emailConfirmed() {
    _analytics.logEvent(
      EventType.emailConfirmed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void loginView() {
    _analytics.logEvent(
      EventType.loginView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  Future<void> loginSuccess(String userEmail) async {
    await _analytics.setUserId(userEmail);
    await _analytics.logEvent(
      EventType.loginSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void loginFailure(String userEmail, String error) {
    _analytics.logEvent(
      EventType.loginFailure,
      eventProperties: {
        PropertyType.error: error,
        PropertyType.email: userEmail,
        PropertyType.id: hashString(userEmail),
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  /// Account
  void account() {
    _analytics.logEvent(
      EventType.account,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePassword() {
    _analytics.logEvent(
      EventType.accountChangePassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePasswordWarning() {
    _analytics.logEvent(
      EventType.accountChangePasswordWarning,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePasswordContinue() {
    _analytics.logEvent(
      EventType.accountChangePasswordContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePasswordCancel() {
    _analytics.logEvent(
      EventType.accountChangePasswordCancel,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountEnterOldPassword() {
    _analytics.logEvent(
      EventType.accountEnterOldPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountSetNewPassword() {
    _analytics.logEvent(
      EventType.accountSetNewPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountSuccessChange() {
    _analytics.logEvent(
      EventType.accountSuccessChange,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePhone() {
    _analytics.logEvent(
      EventType.accountChangePhone,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePhoneWarning() {
    _analytics.logEvent(
      EventType.accountChangePhoneWarning,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePhoneContinue() {
    _analytics.logEvent(
      EventType.accountChangePhoneContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountChangePhoneCancel() {
    _analytics.logEvent(
      EventType.accountChangePhoneCancel,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountEnterNumber() {
    _analytics.logEvent(
      EventType.accountEnterNumber,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void accountSuccessPhone() {
    _analytics.logEvent(
      EventType.accountSuccessPhone,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  /// Full name must be provided e.g. Bitcoin, and not BTC (ticker)
  void assetView(String assetName) {
    _analytics.logEvent(
      EventType.assetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.assetName: assetName,
      },
    );
  }

  void earnProgramView(Source source) {
    _analytics.logEvent(
      EventType.earnProgramView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void kycVerifyProfile(Source source, KycScope scope) {
    _analytics.logEvent(
      EventType.kycVerifyProfile,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: source.name,
        PropertyType.kysScope: scope.name,
      },
    );
  }

  void changeCountryCode(String country) {
    _analytics.logEvent(
      EventType.changeCountryCode,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
        PropertyType.countryOfIssue: countryName,
        PropertyType.documentType: documentType,
      },
    );
  }

  void marketFilter(FilterMarketTabAction marketFilter) {
    _analytics.logEvent(
      EventType.marketFilters,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.marketFilter: marketFilter.name,
      },
    );
  }

  void addToWatchlist(String assetName) {
    _analytics.logEvent(
      EventType.addToWatchlist,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.assetName: assetName,
      },
    );
  }

  void clickMarketBanner(String campaignName, MarketBannerAction action) {
    _analytics.logEvent(
      EventType.clickMarketBanner,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.campaignName: campaignName,
        PropertyType.action: action.name,
      },
    );
  }

  void rewardsScreenView(Source source) {
    _analytics.logEvent(
      EventType.rewardsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void inviteFriendView(Source source) {
    _analytics.logEvent(
      EventType.inviteFriendView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: source.name,
      },
    );
  }

  void buyView(Source source, String assetName) {
    _analytics.logEvent(
      EventType.buyView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
        PropertyType.assetName: assetName,
      },
    );
  }

  void walletAssetView(Source source, String assetName) {
    _analytics.logEvent(
      EventType.walletAssetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: source.name,
        PropertyType.assetName: assetName,
      },
    );
  }

  void kycCameraAllowed() {
    _analytics.logEvent(
      EventType.kycCameraAllowed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: KycScope.kycCameraAllowed.name,
      },
    );
  }

  void kycCameraNotAllowed() {
    _analytics.logEvent(
      EventType.kycCameraNotAllowed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: KycScope.kycCameraNotAllowed.name,
      },
    );
  }

  void kycIdentityUploaded() {
    _analytics.logEvent(
      EventType.kycIdentityUploaded,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: KycScope.kycIdentityUploaded.name,
      },
    );
  }

  void kycIdentityUploadFailed(String error) {
    _analytics.logEvent(
      EventType.kycIdentityUploadFailed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: KycScope.kycIdentityUploadFailed.name,
        PropertyType.error: error,
      },
    );
  }

  void kycSelfieUploaded() {
    _analytics.logEvent(
      EventType.kycSelfieUploaded,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceScreen: KycScope.kycIdentityUploaded.name,
      },
    );
  }

  void kycPhoneConfirmationView() {
    _analytics.logEvent(
      EventType.kycPhoneConfirmationView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycPhoneConfirmed() {
    _analytics.logEvent(
      EventType.kycPhoneConfirmed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycChangePhoneNumber() {
    _analytics.logEvent(
      EventType.kycChangePhoneNumber,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycIdentityScreenView() {
    _analytics.logEvent(
      EventType.kycIdentityScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycPhoneConfirmFailed(String error) {
    _analytics.logEvent(
      EventType.kycPhoneConfirmFailed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycPhoneConfirmFailed: error,
      },
    );
  }

  void kycEnterPhoneNumber() {
    _analytics.logEvent(
      EventType.kycEnterPhoneNumber,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycAllowCameraView() {
    _analytics.logEvent(
      EventType.kycAllowCameraView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycSelfieView() {
    _analytics.logEvent(
      EventType.kycSelfieView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycSuccessPageView() {
    _analytics.logEvent(
      EventType.kycSuccessPageView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycAllowCamera() {
    _analytics.logEvent(
      EventType.kycAllowCamera,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycGiveCameraPermission() {
    _analytics.logEvent(
      EventType.kycGiveCameraPermission,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycTapOnGoToSettings() {
    _analytics.logEvent(
      EventType.kycTapOnGoToSettings,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void kycTapOnEnableCamera() {
    _analytics.logEvent(
      EventType.kycTapOnEnableCamera,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  /// Call when user makes logout.
  /// It will clean unique userId and will generate deviceId,
  /// so the user will appear as a brand new one.
  Future<void> logout() async {
    await _analytics.logEvent(
      EventType.logout,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
    await _analytics.setUserId(null);
  }

  /// Sell
  void sellClick({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.sellClick,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sellSource: source,
      },
    );
  }

  void sellChooseAsset() {
    _analytics.logEvent(
      EventType.sellChooseAsset,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sellChooseAssetClose() {
    _analytics.logEvent(
      EventType.sellChooseAssetClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sellChooseDestination() {
    _analytics.logEvent(
      EventType.sellChooseDestination,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sellForView() {
    _analytics.logEvent(
      EventType.sellForView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sellCloseFor() {
    _analytics.logEvent(
      EventType.sellCloseFor,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.destinationAmount: destinationAmount,
      },
    );
  }

  void sellSuccess() {
    _analytics.logEvent(
      EventType.sellSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  /// Sell
  void convertClick({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.convertClick,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sellSource: source,
      },
    );
  }

  void convertPageView() {
    _analytics.logEvent(
      EventType.convertPageView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void convertSuccess() {
    _analytics.logEvent(
      EventType.convertSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.destinationAmount: destinationAmount,
      },
    );
  }

  /// Receive
  void receiveClick({required String source}) {
    _analytics.logEvent(
      EventType.receiveClick,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceReceive: source,
      },
    );
  }

  void receiveChooseAsset() {
    _analytics.logEvent(
      EventType.receiveChooseAsset,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void receiveChooseAssetClose() {
    _analytics.logEvent(
      EventType.receiveChooseAssetClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void receiveAssetView({required String asset}) {
    _analytics.logEvent(
      EventType.receiveAssetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.assetReceive: asset,
      },
    );
  }

  void receiveCopy({required String asset}) {
    _analytics.logEvent(
      EventType.receiveCopy,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.assetReceive: asset,
      },
    );
  }

  void receiveShare({required String asset}) {
    _analytics.logEvent(
      EventType.receiveShare,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.assetReceive: asset,
      },
    );
  }

  /// Send
  void sendClick({required String source}) {
    _analytics.logEvent(
      EventType.sendClick,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.sourceReceive: source,
      },
    );
  }

  void sendChooseAsset() {
    _analytics.logEvent(
      EventType.sendChooseAsset,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendChooseAssetClose() {
    _analytics.logEvent(
      EventType.sendChooseAssetClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendToView() {
    _analytics.logEvent(
      EventType.sendToView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendToViewClose() {
    _analytics.logEvent(
      EventType.sendToViewClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendChoosePhone() {
    _analytics.logEvent(
      EventType.sendChoosePhone,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendChoosePhoneClose() {
    _analytics.logEvent(
      EventType.sendChoosePhoneClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendContinuePhone() {
    _analytics.logEvent(
      EventType.sendContinuePhone,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendContinueAddress() {
    _analytics.logEvent(
      EventType.sendContinueAddress,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendViews() {
    _analytics.logEvent(
      EventType.sendViews,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
        PropertyType.sendType: type,
      },
    );
  }

  void sendConfirmSend() {
    _analytics.logEvent(
      EventType.sendConfirmSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendNotifyRecipient() {
    _analytics.logEvent(
      EventType.sendNotifyRecipient,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendTapOnSendMessage() {
    _analytics.logEvent(
      EventType.sendTapOnSendMessage,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void sendTapOnSendLater() {
    _analytics.logEvent(
      EventType.sendTapOnSendLater,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void earnOnBoardingView() {
    _analytics.logEvent(
      EventType.earnOnBoardingView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void earnClickMore() {
    _analytics.logEvent(
      EventType.earnClickMore,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void earnCloseOnboarding() {
    _analytics.logEvent(
      EventType.earnCloseOnboarding,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void earnTapAvailable({
    required String assetName,
  }) {
    _analytics.logEvent(
      EventType.earnTapAvailable,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  /// Banner account
  void bannerClick({
    required String bannerName,
  }) {
    _analytics.logEvent(
      EventType.accountBannerClick,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
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
        PropertyType.techAcc: isTechAcc,
        PropertyType.isLoaded: isFinished,
      },
    );
  }

  void initFinished() {
    _analytics.logEvent(
      EventType.initFinished,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void remoteConfig() {
    _analytics.logEvent(
      EventType.remoteConfig,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void remoteConfigError() {
    _analytics.logEvent(
      EventType.remoteConfigError,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  /// NFT

  void nftPromoOpenPromo() {
    _analytics.logEvent(
      EventType.iHavePromoCode,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPromoEnterPromo() {
    _analytics.logEvent(
      EventType.enterPromoCode,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPromoClosePromo() {
    _analytics.logEvent(
      EventType.closePromoCode,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPromoContinuePromo({
    required String promoCode,
  }) {
    _analytics.logEvent(
      EventType.tapOnContinuePromoCode,
      eventProperties: {
        'Promo code': promoCode,
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftMarketOpen() {
    _analytics.logEvent(
      EventType.nftMarketOpen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftMarketTapCollection({
    required String collectionTitle,
    required String nftNumberPictures,
    required String nftCategories,
  }) {
    _analytics.logEvent(
      EventType.nftMarketTapCollection,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.collectionTitle: collectionTitle,
        PropertyType.nftNumberPictures: nftNumberPictures,
        PropertyType.nftCategories: nftCategories,
      },
    );
  }

  void nftMarketTapFilter() {
    _analytics.logEvent(
      EventType.nftMarketTapFilter,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftMarketFilterShowed() {
    _analytics.logEvent(
      EventType.nftMarketFilterShowed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftMarketFilterClose({
    required String nftCloseMethod,
  }) {
    _analytics.logEvent(
      EventType.nftMarketFilterClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.collectionTitle: nftCloseMethod,
      },
    );
  }

  void nftCollectionView({
    required String nftCollectionID,
    required String source,
  }) {
    _analytics.logEvent(
      EventType.nftCollectionView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.source: source,
      },
    );
  }

  void nftCollectionTapSort() {
    _analytics.logEvent(
      EventType.nftCollectionTapSort,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftCollectionSortView() {
    _analytics.logEvent(
      EventType.nftCollectionSortView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftCollectionSortClose({
    required String nftSortingOption,
  }) {
    _analytics.logEvent(
      EventType.nftCollectionSortClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftSortingOption: nftSortingOption,
      },
    );
  }

  void nftCollectionSortApply({
    required String nftSortingOption,
  }) {
    _analytics.logEvent(
      EventType.nftCollectionSortApply,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftSortingOption: nftSortingOption,
      },
    );
  }

  void nftCollectionTapHide() {
    _analytics.logEvent(
      EventType.nftCollectionTapHide,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftCollectionTapShow() {
    _analytics.logEvent(
      EventType.nftCollectionTapShow,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftObjectTap({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectView({
    required String nftCollectionID,
    required String nftObjectId,
    required String source,
  }) {
    _analytics.logEvent(
      EventType.nftObjectView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.source: source,
      },
    );
  }

  void nftObjectTapBack({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapBack,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectTapCollection({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapCollection,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectTapCurrency({
    required String nftCollectionID,
    required String nftObjectId,
    required String currency,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapCurrency,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.currency: currency,
      },
    );
  }

  void nftObjectTapBuy({
    required String nftCollectionID,
    required String nftObjectId,
    required String currency,
    required String nftPrice,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapBuy,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.currency: currency,
        PropertyType.nftPrice: nftPrice,
      },
    );
  }

  void nftObjectNotEnoughAsset({
    required String nftCollectionID,
    required String nftObjectId,
    required String currency,
    required String nftPrice,
  }) {
    _analytics.logEvent(
      EventType.nftObjectNotEnoughAsset,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.currency: currency,
        PropertyType.nftPrice: nftPrice,
      },
    );
  }

  void nftObjectTapGetAsset({
    required String nftCollectionID,
    required String nftObjectId,
    required String currency,
    required String nftPrice,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapGetAsset,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.currency: currency,
        PropertyType.nftPrice: nftPrice,
      },
    );
  }

  void nftObjectCloseNotEnough({
    required String nftCollectionID,
    required String nftObjectId,
    required String currency,
    required String nftPrice,
    required String method,
  }) {
    _analytics.logEvent(
      EventType.nftObjectCloseNotEnough,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.currency: currency,
        PropertyType.nftPrice: nftPrice,
        PropertyType.method: method,
      },
    );
  }

  void nftObjectTapPicture({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapPicture,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectPictureView({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectPictureView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectPictureClose({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectPictureClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectTapShare({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapShare,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectShareView({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectShareView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectTapCopy({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapCopy,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftObjectTapShareTap({
    required String nftCollectionID,
    required String nftObjectId,
    required String source,
  }) {
    _analytics.logEvent(
      EventType.nftObjectTapShareTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.source: source,
      },
    );
  }

  void nftObjectShareClose({
    required String nftCollectionID,
    required String nftObjectId,
    required String method,
  }) {
    _analytics.logEvent(
      EventType.nftObjectShareClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.method: method,
      },
    );
  }

  void nftPurchaseConfirmView({
    required String nftCollectionID,
    required String nftObjectId,
    required String nftPrice,
    required String currency,
    required String nftAmountToBePaid,
    required String nftPromoCode,
  }) {
    _analytics.logEvent(
      EventType.nftPurchaseConfirmView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftPrice: nftPrice,
        PropertyType.currency: currency,
        PropertyType.nftAmountToBePaid: nftAmountToBePaid,
        PropertyType.nftPromoCode: nftPromoCode,
      },
    );
  }

  void nftPurchaseTapBack({
    required String nftCollectionID,
    required String nftObjectId,
    required String nftPrice,
    required String currency,
    required String nftAmountToBePaid,
  }) {
    _analytics.logEvent(
      EventType.nftPurchaseTapBack,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftPrice: nftPrice,
        PropertyType.currency: currency,
        PropertyType.nftAmountToBePaid: nftAmountToBePaid,
      },
    );
  }

  void nftPurchaseConfirmTap({
    required String nftCollectionID,
    required String nftObjectId,
    required String nftPrice,
    required String currency,
    required String nftAmountToBePaid,
    required String nftPromoCode,
  }) {
    _analytics.logEvent(
      EventType.nftPurchaseConfirmTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftPrice: nftPrice,
        PropertyType.currency: currency,
        PropertyType.nftAmountToBePaid: nftAmountToBePaid,
        PropertyType.nftPromoCode: nftPromoCode,
      },
    );
  }

  void nftPurchaseProcessing({
    required String nftCollectionID,
    required String nftObjectId,
    required String nftPrice,
    required String currency,
    required String nftAmountToBePaid,
    required String nftPromoCode,
  }) {
    _analytics.logEvent(
      EventType.nftPurchaseProcessing,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftPrice: nftPrice,
        PropertyType.currency: currency,
        PropertyType.nftAmountToBePaid: nftAmountToBePaid,
        PropertyType.nftPromoCode: nftPromoCode,
      },
    );
  }

  void nftPurchaseSuccess({
    required String nftCollectionID,
    required String nftObjectId,
    required String nftPrice,
    required String currency,
    required String nftAmountToBePaid,
    required String nftPromoCode,
  }) {
    _analytics.logEvent(
      EventType.nftPurchaseSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftPrice: nftPrice,
        PropertyType.currency: currency,
        PropertyType.nftAmountToBePaid: nftAmountToBePaid,
        PropertyType.nftPromoCode: nftPromoCode,
      },
    );
  }

  void nftPurchaseDisplayed({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftPurchaseDisplayed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftPortfolioTapNft() {
    _analytics.logEvent(
      EventType.nftPortfolioTapNft,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPortfolioNFTView() {
    _analytics.logEvent(
      EventType.nftPortfolioNFTView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPortfolioHistory() {
    _analytics.logEvent(
      EventType.nftPortfolioHistory,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPortfolioHistoryView() {
    _analytics.logEvent(
      EventType.nftPortfolioHistoryView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPortfolioBuy() {
    _analytics.logEvent(
      EventType.nftPortfolioBuy,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftPortfolioReceive() {
    _analytics.logEvent(
      EventType.nftPortfolioReceive,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftWalletTapObject({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletTapObject,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletObjectView({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletObjectView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletActionTap({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletActionTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletActionView({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletActionView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletStatsTap({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletStatsTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletHistory({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletHistory,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletTapHistoryObject({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletTapHistoryObject,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletHistoryObjectView({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletHistoryObjectView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletTapCollection({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletTapCollection,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletCollectionView({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletCollectionView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftWalletObjectFull({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftWalletObjectFull,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftSellTap({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftSellTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftSellPreview({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftSellPreview,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftSellPreviewTap({
    required String nftCollectionID,
    required String nftObjectId,
    required String asset,
    required String nftPriceAmount,
  }) {
    _analytics.logEvent(
      EventType.nftSellPreviewTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.asset: asset,
        PropertyType.nftPriceAmount: nftPriceAmount,
      },
    );
  }

  void nftSellConfirmView({
    required String nftCollectionID,
    required String nftObjectId,
    required String asset,
    required String nftPriceAmount,
    required String nftOperationFee,
    required String nftCreatorFee,
    required String nftAmountToGet,
  }) {
    _analytics.logEvent(
      EventType.nftSellConfirmView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.asset: asset,
        PropertyType.nftPriceAmount: nftPriceAmount,
        PropertyType.nftOperationFee: nftOperationFee,
        PropertyType.nftCreatorFee: nftCreatorFee,
        PropertyType.nftAmountToGet: nftAmountToGet,
      },
    );
  }

  void nftSellConfirmTap({
    required String nftCollectionID,
    required String nftObjectId,
    required String asset,
    required String nftPriceAmount,
    required String nftOperationFee,
    required String nftCreatorFee,
    required String nftAmountToGet,
  }) {
    _analytics.logEvent(
      EventType.nftSellConfirmTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.asset: asset,
        PropertyType.nftPriceAmount: nftPriceAmount,
        PropertyType.nftOperationFee: nftOperationFee,
        PropertyType.nftCreatorFee: nftCreatorFee,
        PropertyType.nftAmountToGet: nftAmountToGet,
      },
    );
  }

  void nftSellProcessing({
    required String nftCollectionID,
    required String nftObjectId,
    required String asset,
    required String nftPriceAmount,
    required String nftOperationFee,
    required String nftCreatorFee,
    required String nftAmountToGet,
  }) {
    _analytics.logEvent(
      EventType.nftSellProcessing,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.asset: asset,
        PropertyType.nftPriceAmount: nftPriceAmount,
        PropertyType.nftOperationFee: nftOperationFee,
        PropertyType.nftCreatorFee: nftCreatorFee,
        PropertyType.nftAmountToGet: nftAmountToGet,
      },
    );
  }

  void nftSellSuccess({
    required String nftCollectionID,
    required String nftObjectId,
    required String asset,
    required String nftPriceAmount,
    required String nftOperationFee,
    required String nftCreatorFee,
    required String nftAmountToGet,
  }) {
    _analytics.logEvent(
      EventType.nftSellSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.asset: asset,
        PropertyType.nftPriceAmount: nftPriceAmount,
        PropertyType.nftOperationFee: nftOperationFee,
        PropertyType.nftCreatorFee: nftCreatorFee,
        PropertyType.nftAmountToGet: nftAmountToGet,
      },
    );
  }

  void nftSellCancelTap({
    required String nftCollectionID,
    required String nftObjectId,
    required String asset,
    required String nftPriceAmount,
    required String nftOperationFee,
    required String nftCreatorFee,
    required String nftAmountToGet,
  }) {
    _analytics.logEvent(
      EventType.nftSellCancelTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.asset: asset,
        PropertyType.nftPriceAmount: nftPriceAmount,
        PropertyType.nftOperationFee: nftOperationFee,
        PropertyType.nftCreatorFee: nftCreatorFee,
        PropertyType.nftAmountToGet: nftAmountToGet,
      },
    );
  }

  void nftSellConfirmBack({
    required String nftCollectionID,
    required String nftObjectId,
    required String asset,
    required String nftPriceAmount,
    required String nftOperationFee,
    required String nftCreatorFee,
    required String nftAmountToGet,
  }) {
    _analytics.logEvent(
      EventType.nftSellConfirmBack,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.asset: asset,
        PropertyType.nftPriceAmount: nftPriceAmount,
        PropertyType.nftOperationFee: nftOperationFee,
        PropertyType.nftCreatorFee: nftCreatorFee,
        PropertyType.nftAmountToGet: nftAmountToGet,
      },
    );
  }

  void nftSellPreviewBack({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftSellPreviewBack,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftSendTap({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftSendTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftSendView({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftSendView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftSendBack({
    required String nftCollectionID,
    required String nftObjectId,
  }) {
    _analytics.logEvent(
      EventType.nftSendBack,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
      },
    );
  }

  void nftSendContinue({
    required String nftCollectionID,
    required String nftObjectId,
    required String network,
  }) {
    _analytics.logEvent(
      EventType.nftSendContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftNetwork: network,
      },
    );
  }

  void nftSendConfirmView({
    required String nftCollectionID,
    required String nftObjectId,
    required String network,
    required String nftFee,
  }) {
    _analytics.logEvent(
      EventType.nftSendConfirmView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftNetwork: network,
        PropertyType.nftFee: nftFee,
      },
    );
  }

  void nftSendConfirmBack({
    required String nftCollectionID,
    required String nftObjectId,
    required String network,
    required String nftFee,
  }) {
    _analytics.logEvent(
      EventType.nftSendConfirmBack,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftNetwork: network,
        PropertyType.nftFee: nftFee,
      },
    );
  }

  void nftSendConfirmTap({
    required String nftCollectionID,
    required String nftObjectId,
    required String network,
    required String nftFee,
  }) {
    _analytics.logEvent(
      EventType.nftSendConfirmTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftNetwork: network,
        PropertyType.nftFee: nftFee,
      },
    );
  }

  void nftSendProcessing({
    required String nftCollectionID,
    required String nftObjectId,
    required String network,
    required String nftFee,
  }) {
    _analytics.logEvent(
      EventType.nftSendProcessing,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftNetwork: network,
        PropertyType.nftFee: nftFee,
      },
    );
  }

  void nftSendSuccess({
    required String nftCollectionID,
    required String nftObjectId,
    required String network,
    required String nftFee,
  }) {
    _analytics.logEvent(
      EventType.nftSendSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.nftCollectionID: nftCollectionID,
        PropertyType.nftObjectId: nftObjectId,
        PropertyType.nftNetwork: network,
        PropertyType.nftFee: nftFee,
      },
    );
  }

  void nftReceiveTap({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.nftReceiveTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.source: source,
      },
    );
  }

  void nftReceiveShareTap() {
    _analytics.logEvent(
      EventType.nftReceiveShareTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftReceiveCopyTap() {
    _analytics.logEvent(
      EventType.nftReceiveCopyTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  void nftReceiveBack() {
    _analytics.logEvent(
      EventType.nftReceiveBack,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
      },
    );
  }

  /// New buy flow
  void newBuyZeroScreenView() {
    if (!newBuyZeroScreenViewSent) {
      newBuyZeroScreenViewSent = true;
      _analytics.logEvent(
        EventType.newBuyZeroScreenView,
        eventProperties: {
          PropertyType.techAcc: isTechAcc,
          PropertyType.eventId: '1',
        },
      );
    }
  }

  void newBuyTapBuy() {
    _analytics.logEvent(
      EventType.newBuyTapBuy,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '2',
      },
    );
  }

  void newBuyChooseAssetView() {
    _analytics.logEvent(
      EventType.newBuyChooseAssetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '3',
      },
    );
  }

  void newBuyNoSavedCard() {
    _analytics.logEvent(
      EventType.newBuyNoSavedCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '4',
      },
    );
  }

  void newBuyTapAddCard() {
    _analytics.logEvent(
      EventType.newBuyTapAddCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '5',
      },
    );
  }

  void newBuyEnterCardDetailsView({
    required String nameVisible,
  }) {
    _analytics.logEvent(
      EventType.newBuyEnterCardDetailsView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '6',
        PropertyType.nameLastName: nameVisible,
      },
    );
  }

  void newBuyTapSaveCard() {
    _analytics.logEvent(
      EventType.newBuyTapSaveCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '7',
      },
    );
  }

  void newBuyTapCardContinue({
    required String saveCard,
  }) {
    _analytics.logEvent(
      EventType.newBuyTapCardContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '8',
        PropertyType.saveCard: saveCard,
      },
    );
  }

  void newBuyBuyAssetView({
    required String asset,
  }) {
    _analytics.logEvent(
      EventType.newBuyBuyAssetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '9',
        PropertyType.asset: asset,
      },
    );
  }

  void newBuyErrorLimit({
    required String errorCode,
    required String asset,
  }) {
    _analytics.logEvent(
      EventType.newBuyErrorLimit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '10',
        PropertyType.asset: asset,
        PropertyType.errorCode: errorCode,
      },
    );
  }

  void newBuyTapCardLimits() {
    _analytics.logEvent(
      EventType.newBuyTapCardLimits,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '11',
      },
    );
  }

  void newBuyCardLimitsView() {
    _analytics.logEvent(
      EventType.newBuyCardLimitsView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '12',
      },
    );
  }

  void newBuyTapCurrency() {
    _analytics.logEvent(
      EventType.newBuyTapCurrency,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '13',
      },
    );
  }

  void newBuyChooseCurrencyView() {
    _analytics.logEvent(
      EventType.newBuyChooseCurrencyView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '14',
      },
    );
  }

  void newBuyTapContinue({
    required String sourceCurrency,
    required String destinationCurrency,
    required String paymentMethod,
    required String sourceAmount,
    required String destinationAmount,
    required String quickAmount,
  }) {
    _analytics.logEvent(
      EventType.newBuyTapContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '15',
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationAmount: destinationAmount,
        PropertyType.preset: quickAmount,
      },
    );
  }

  void newBuyOrderSummaryView() {
    _analytics.logEvent(
      EventType.newBuyOrderSummaryView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '16',
      },
    );
  }

  void newBuyTapAgreement() {
    _analytics.logEvent(
      EventType.newBuyTapAgreement,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '17',
      },
    );
  }

  void newBuyTapConfirm({
    required String sourceCurrency,
    required String destinationCurrency,
    required String paymentMethod,
    required String sourceAmount,
    required String destinationAmount,
    required String exchangeRate,
    required String paymentFee,
    required String firstTimeBuy,
  }) {
    _analytics.logEvent(
      EventType.newBuyTapConfirm,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '18',
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.destinationAmount: destinationAmount,
        PropertyType.exchangeRate: exchangeRate,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.paymentFee: paymentFee,
        PropertyType.firstTimeBuy: firstTimeBuy,
      },
    );
  }

  void newBuyTapPaymentFee() {
    _analytics.logEvent(
      EventType.newBuyTapPaymentFee,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '19',
      },
    );
  }

  void newBuyFeeView({
    required String paymentFee,
  }) {
    _analytics.logEvent(
      EventType.newBuyFeeView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '20',
        PropertyType.paymentFee: paymentFee,
      },
    );
  }

  void newBuyEnterCvvView({
    required String firstTimeBuy,
  }) {
    _analytics.logEvent(
      EventType.newBuyEnterCvvView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '21',
        PropertyType.firstTimeBuy: firstTimeBuy,
      },
    );
  }

  void newBuyProcessingView({
    required String firstTimeBuy,
  }) {
    _analytics.logEvent(
      EventType.newBuyProcessingView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '22',
        PropertyType.firstTimeBuy: firstTimeBuy,
      },
    );
  }

  void newBuyTapCloseProcessing({
    required String firstTimeBuy,
  }) {
    _analytics.logEvent(
      EventType.newBuyTapCloseProcessing,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '23',
        PropertyType.firstTimeBuy: firstTimeBuy,
      },
    );
  }

  void newBuySuccessView({
    required String firstTimeBuy,
  }) {
    _analytics.logEvent(
      EventType.newBuySuccessView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '24',
        PropertyType.firstTimeBuy: firstTimeBuy,
      },
    );
  }

  void newBuyFailedView({
    required String firstTimeBuy,
    required String errorCode,
  }) {
    _analytics.logEvent(
      EventType.newBuyFailedView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '25',
        PropertyType.firstTimeBuy: firstTimeBuy,
        PropertyType.errorCode: errorCode,
      },
    );
  }

  void newBuyTapEdit() {
    _analytics.logEvent(
      EventType.newBuyTapEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '26',
      },
    );
  }

  void newBuyTapDelete() {
    _analytics.logEvent(
      EventType.newBuyTapDelete,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '27',
      },
    );
  }

  void newBuyDeleteView() {
    _analytics.logEvent(
      EventType.newBuyDeleteView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '28',
      },
    );
  }

  void newBuyTapYesDelete() {
    _analytics.logEvent(
      EventType.newBuyTapYesDelete,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '29',
      },
    );
  }

  void newBuyTapCancelDelete() {
    _analytics.logEvent(
      EventType.newBuyTapCancelDelete,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '30',
      },
    );
  }
}
