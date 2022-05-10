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
      await _analytics.setUserId(hashString(userEmail));
    }
  }

  void onboardingView() {
    _analytics.logEvent(EventType.onboardingView);
  }

  void signUpView() {
    _analytics.logEvent(EventType.signUpView);
  }

  Future<void> signUpSuccess(String userEmail) async {
    await _analytics.setUserId(hashString(userEmail));

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
    await _analytics.setUserId(hashString(userEmail));
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

  void sellView(Source source, String assetName) {
    _analytics.logEvent(
      EventType.sellView,
      eventProperties: {
        PropertyType.sourceScreen: source.name,
        PropertyType.assetName: assetName,
      },
    );
  }

  void buySheetView() => _analytics.logEvent(EventType.buySheetView);
  void sellSheetView() => _analytics.logEvent(EventType.sellSheetView);

  void earnDetailsView(String assetName) {
    _analytics.logEvent(
      EventType.earnDetailsView,
      eventProperties: {
        PropertyType.assetName: assetName,
      },
    );
  }

  void depositCryptoView(String assetName) {
    _analytics.logEvent(
      EventType.depositView,
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

  /// Call when user makes logout.
  /// It will clean unique userId and will generate deviceId,
  /// so the user will appear as a brand new one.
  Future<void> logout() async {
    await _analytics.logEvent(EventType.logout);
    await _analytics.setUserId(null);
    await _analytics.regenerateDeviceId();
  }

  void tapPreviewBuy(String assetName, String paymentMethod, String amount) {
    _analytics.logEvent(
      EventType.tapPreviewBuy,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.amount: amount,
      },
    );
  }

  void previewBuyView(String assetName, String paymentMethod, String amount) {
    _analytics.logEvent(
      EventType.previewBuyView,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.amount: amount,
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
}
