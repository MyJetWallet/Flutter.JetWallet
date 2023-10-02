import 'package:amplitude_flutter/amplitude.dart';

import '../simple_analytics.dart';
import 'models/event_type.dart';
import 'models/property_type.dart';

final sAnalytics = SimpleAnalytics();

class SimpleAnalytics {
  factory SimpleAnalytics() => _instance;

  SimpleAnalytics._internal();

  static final SimpleAnalytics _instance = SimpleAnalytics._internal();

  final _analytics = Amplitude.getInstance();

  bool isTechAcc = false;
  bool newBuyZeroScreenViewSent = false;
  int kycDepositStatus = 0;

  /// Run at the start of the app
  ///
  /// Provide:
  /// 1. environmentKey for Amplitude workspace
  /// 2. userEmail if user is already authenticated
  Future<void> init(
    String environmentKey,
    // ignore: avoid_positional_boolean_parameters
    bool techAcc, [
    String? userEmail,
  ]) async {
    await _analytics.init(environmentKey);

    if (userEmail != null) {
      await _analytics.setUserId(userEmail);
    }

    isTechAcc = techAcc;
  }

  // ignore: avoid_setters_without_getters
  set updateTechAccValue(bool techAcc) => isTechAcc = techAcc;

  // ignore: avoid_setters_without_getters
  set setKYCDepositStatus(int status) => kycDepositStatus = status;

  void updateUserId(String newId) {
    _analytics.setUserId(newId);
  }

  /// Buy flow
  void newBuyZeroScreenView() {
    if (!newBuyZeroScreenViewSent) {
      newBuyZeroScreenViewSent = true;
      _analytics.logEvent(
        EventType.newBuyZeroScreenView,
        eventProperties: {
          PropertyType.techAcc: isTechAcc,
          PropertyType.eventId: '1',
          PropertyType.kycStatus: kycDepositStatus,
        },
      );
    }
  }

  void newBuyTapBuy({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.newBuyTapBuy,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '2',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void newBuyChooseAssetView() {
    _analytics.logEvent(
      EventType.newBuyChooseAssetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '3',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void newBuyNoSavedCard() {
    _analytics.logEvent(
      EventType.newBuyNoSavedCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '4',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void newBuyTapAddCard() {
    _analytics.logEvent(
      EventType.newBuyTapAddCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '5',
        PropertyType.kycStatus: kycDepositStatus,
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
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void newBuyBuyAssetView({
    required String asset,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuyBuyAssetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '9',
        PropertyType.asset: asset,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuyErrorLimit({
    required String errorCode,
    required String asset,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuyErrorLimit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '10',
        PropertyType.asset: asset,
        PropertyType.errorCode: errorCode,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuyTapContinue({
    required String sourceCurrency,
    required String destinationCurrency,
    required String sourceAmount,
    required String destinationAmount,
    required String quickAmount,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuyTapContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '15',
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.destinationCurrency: destinationCurrency,
        PropertyType.sourceAmount: sourceAmount,
        PropertyType.destinationAmount: destinationAmount,
        PropertyType.newBuyPreset: quickAmount,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuyOrderSummaryView({
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuyOrderSummaryView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '16',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuyTapConfirm({
    required String sourceCurrency,
    required String destinationCurrency,
    required String sourceAmount,
    required String destinationAmount,
    required String exchangeRate,
    required String paymentFee,
    required String firstTimeBuy,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
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
        PropertyType.paymentFee: paymentFee,
        PropertyType.firstTimeBuy: firstTimeBuy,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuyTapPaymentFee() {
    _analytics.logEvent(
      EventType.newBuyTapPaymentFee,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '19',
        PropertyType.kycStatus: kycDepositStatus,
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
        PropertyType.kycStatus: kycDepositStatus,
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
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void newBuyProcessingView({
    required String firstTimeBuy,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuyProcessingView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '22',
        PropertyType.firstTimeBuy: firstTimeBuy,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuyTapCloseProcessing({
    required String firstTimeBuy,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuyTapCloseProcessing,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '23',
        PropertyType.firstTimeBuy: firstTimeBuy,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuySuccessView({
    required String firstTimeBuy,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuySuccessView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '24',
        PropertyType.firstTimeBuy: firstTimeBuy,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void newBuyFailedView({
    required String firstTimeBuy,
    required String errorCode,
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.newBuyFailedView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '25',
        PropertyType.firstTimeBuy: firstTimeBuy,
        PropertyType.errorCode: errorCode,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  /// Sign Up & Sign In Flow

  void signInFlowWelcomeView() {
    _analytics.logEvent(
      EventType.signInFlowWelcomeView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '31',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowOnboardingFirstScreenView() {
    _analytics.logEvent(
      EventType.signInFlowOnboardingFirstScreenView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '32',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowOnboardingSecondScreenView() {
    _analytics.logEvent(
      EventType.signInFlowOnboardingSecondScreenView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '33',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowOnboardingThirdScreenView() {
    _analytics.logEvent(
      EventType.signInFlowOnboardingThirdScreenView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '34',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowOnboardingFourScreenView() {
    _analytics.logEvent(
      EventType.signInFlowOnboardingFourScreenView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '35',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowTapGetStarted() {
    _analytics.logEvent(
      EventType.signInFlowTapGetStarted,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '36',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowEnterEmailView() {
    _analytics.logEvent(
      EventType.signInFlowEnterEmailView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '37',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowTapToAgreeTCPP() {
    _analytics.logEvent(
      EventType.signInFlowTapToAgreeTCPP,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '38',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowEmailContinue() {
    _analytics.logEvent(
      EventType.signInFlowEmailContinue,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '39',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowEmailVerificationView() {
    _analytics.logEvent(
      EventType.signInFlowEmailVerificationView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '40',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowOpenEmailApp() {
    _analytics.logEvent(
      EventType.signInFlowOpenEmailApp,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '41',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowSelectAnAppScreenView() {
    _analytics.logEvent(
      EventType.signInFlowSelectAnAppScreenView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '42',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowTapRememberMyChoice() {
    _analytics.logEvent(
      EventType.signInFlowTapRememberMyChoice,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '43',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowTapResend() {
    _analytics.logEvent(
      EventType.signInFlowTapResend,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '44',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPleaseWait() {
    _analytics.logEvent(
      EventType.signInFlowPleaseWait,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '45',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowErrorVerificationCode() {
    _analytics.logEvent(
      EventType.signInFlowErrorVerificationCode,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '46',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPhoneNumberView() {
    _analytics.logEvent(
      EventType.signInFlowPhoneNumberView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '47',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPhoneNumberContinue() {
    _analytics.logEvent(
      EventType.signInFlowPhoneNumberContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '48',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPhoneConfirmView() {
    _analytics.logEvent(
      EventType.signInFlowPhoneConfirmView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '49',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPhoneReceiveCodePhoneCall() {
    _analytics.logEvent(
      EventType.signInFlowPhoneReceiveCodePhoneCall,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '50',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPhoneConfirmWrongPhone({required String errorCode}) {
    _analytics.logEvent(
      EventType.signInFlowPhoneConfirmWrongPhone,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '51',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
      },
    );
  }

  void signInFlowPersonalDetailsView() {
    _analytics.logEvent(
      EventType.signInFlowPersonalDetailsView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '52',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowDateSheetView() {
    _analytics.logEvent(
      EventType.signInFlowDateSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '53',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowDateContinue() {
    _analytics.logEvent(
      EventType.signInFlowDateContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '54',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowSelectCountryView() {
    _analytics.logEvent(
      EventType.signInFlowSelectCountryView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '55',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowErrorCountryBlocked({required String erroCode}) {
    _analytics.logEvent(
      EventType.signInFlowErrorCountryBlocked,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '56',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: erroCode,
      },
    );
  }

  void signInFlowPersonalContinue() {
    _analytics.logEvent(
      EventType.signInFlowPersonalContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '57',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPersonalScreenViewLoading() {
    _analytics.logEvent(
      EventType.signInFlowPersonalScreenViewLoading,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '58',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPersonalReferralLink() {
    _analytics.logEvent(
      EventType.signInFlowPersonalReferralLink,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '59',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPersonaReferralLinkScreenView() {
    _analytics.logEvent(
      EventType.signInFlowPersonaReferralLinkScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '60',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowPersonaReferralLinkError({required String errorCode}) {
    _analytics.logEvent(
      EventType.signInFlowPersonaReferralLinkError,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '61',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
      },
    );
  }

  void signInFlowPersonaReferralLinkContinue({required String code}) {
    _analytics.logEvent(
      EventType.signInFlowPersonaReferralLinkContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '62',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.codeLink: code,
      },
    );
  }

  void signInFlowCreatePinView() {
    _analytics.logEvent(
      EventType.signInFlowCreatePinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '63',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowConfirmPinView() {
    _analytics.logEvent(
      EventType.signInFlowConfirmPinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '64',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowErrorPin({
    required String error,
  }) {
    _analytics.logEvent(
      EventType.signInFlowErrorPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '65',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: error,
      },
    );
  }

  void signInFlowEnableBiometricView({
    required String biometric,
  }) {
    _analytics.logEvent(
      EventType.signInFlowEnableBiometricView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '66',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.biometric: biometric,
      },
    );
  }

  void signInFlowEnableFaceID({
    required String biometric,
  }) {
    _analytics.logEvent(
      EventType.signInFlowEnableFaceID,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '67',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.biometric: biometric,
      },
    );
  }

  void signInFlowLaterFaceID({
    required String biometric,
  }) {
    _analytics.logEvent(
      EventType.signInFlowLaterFaceID,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '68',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.biometric: biometric,
      },
    );
  }

  void signInFlowFaceIDScreenView({
    required String biometric,
  }) {
    _analytics.logEvent(
      EventType.signInFlowFaceIDScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '69',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.biometric: biometric,
      },
    );
  }

  void signInFlowFaceAllowFaceID({
    required String biometric,
  }) {
    _analytics.logEvent(
      EventType.signInFlowFaceAllowFaceID,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '70',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.biometric: biometric,
      },
    );
  }

  void signInFlowFaceDontAllowFaceID({
    required String biometric,
  }) {
    _analytics.logEvent(
      EventType.signInFlowFaceDontAllowFaceID,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '71',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.biometric: biometric,
      },
    );
  }

  void signInFlowEnterPinView() {
    _analytics.logEvent(
      EventType.signInFlowEnterPinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '72',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void signInFlowVerificationPassed() {
    _analytics.logEvent(
      EventType.signInFlowVerificationPassed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '73',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void paymentMethodScreenView() {
    _analytics.logEvent(
      EventType.paymentMethodScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '74',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void paymentCurrencyPopupScreenView(String currency) {
    _analytics.logEvent(
      EventType.paymentCurrencyPopupScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '75',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodCurrency: currency,
      },
    );
  }

  void paymentWevViewScreenView({
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.paymentWevViewScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '76',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void paymentWevViewClose({
    required String paymentMethodType,
    required String paymentMethodName,
    required String paymentMethodCurrency,
  }) {
    _analytics.logEvent(
      EventType.paymentWevViewClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '77',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.paymentMethodType: paymentMethodType,
        PropertyType.paymentMethodName: paymentMethodName,
        PropertyType.paymentMethodCurrency: paymentMethodCurrency,
      },
    );
  }

  void verificationProfileScreenView() {
    _analytics.logEvent(
      EventType.verificationProfileScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '116',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void verificationProfileLogout() {
    _analytics.logEvent(
      EventType.verificationProfileLogout,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '117',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void verificationProfileProvideInfo() {
    _analytics.logEvent(
      EventType.verificationProfileProvideInfo,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '118',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void verificationProfileCreatePIN() {
    _analytics.logEvent(
      EventType.verificationProfileCreatePIN,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '119',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  // Crypto wallet send

  void cryptoSendChooseAssetScreenView({
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendChooseAssetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '120',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendSendAssetNameScreenView({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendSendAssetNameScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '121',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendChooseNetworkScreenView({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendChooseNetworkScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '122',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendTapQr({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendTapQr,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '123',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendTapPaste({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendTapPaste,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '124',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendTapContinue({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendTapContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '125',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendAssetNameAmountScreenView({
    required String asset,
    required String network,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendAssetNameAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '126',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendErrorLimit({
    required String errorCode,
    required String asset,
    required String network,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendErrorLimit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '127',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cryptoSendTapContinueAmountScreen({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
    required String preset,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendTapContinueAmountScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '128',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.preset: preset,
      },
    );
  }

  void cryptoSendOrderSummarySend({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
    required String paymentFee,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendOrderSummarySend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '129',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
      },
    );
  }

  void cryptoSendTapConfirmOrder({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
    required String paymentFee,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendTapConfirmOrder,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '130',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
      },
    );
  }

  void cryptoSenLoadingOrderSummary({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
    required String paymentFee,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendLoadingOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '131',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
      },
    );
  }

  void cryptoSendBioApprove({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
    required String paymentFee,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendBioApprove,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '132',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
      },
    );
  }

  void cryptoSendFailedSend({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
    required String paymentFee,
    required String failedReason,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendFailedSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '133',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
        PropertyType.failedReason: failedReason,
      },
    );
  }

  void cryptoSendSuccessSend({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
    required String paymentFee,
  }) {
    _analytics.logEvent(
      EventType.cryptoSendSuccessSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '134',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
      },
    );
  }

  //

  void tapOnTheReceiveButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheReceiveButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '169',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void chooseAssetToReceiveScreenView() {
    _analytics.logEvent(
      EventType.chooseAssetToReceiveScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '170',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void chooseNetworkPopupView({
    required String asset,
  }) {
    _analytics.logEvent(
      EventType.chooseNetworkPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '171',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
      },
    );
  }

  void receiveAssetScreenView({
    required String asset,
    required String network,
  }) {
    _analytics.logEvent(
      EventType.receiveAssetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '172',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
      },
    );
  }

  void tapOnTheButtonNetworkOnReceiveAssetScreen({
    required String asset,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonNetworkOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '173',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
      },
    );
  }

  void chooseNetworkPopupViewShowedOnReceiveAssetScreen({
    required String asset,
  }) {
    _analytics.logEvent(
      EventType.chooseNetworkPopupViewShowedOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '174',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
      },
    );
  }

  void tapOnTheButtonCopyOnReceiveAssetScreen({
    required String asset,
    required String network,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonCopyOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '175',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
      },
    );
  }

  void tapOnTheButtonShareOnReceiveAssetScreen({
    required String asset,
    required String network,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonShareOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '176',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
      },
    );
  }

  // KYC

  void kycFlowVerificationScreenView() {
    _analytics.logEvent(
      EventType.kycFlowVerificationScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '177',
        PropertyType.kycStatus: kycDepositStatus
      },
    );
  }

  void kycFlowProvideInformation() {
    _analytics.logEvent(
      EventType.kycFlowProvideInformation,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '178',
        PropertyType.kycStatus: kycDepositStatus
      },
    );
  }

  void kycFlowVerifyYourIdentify() {
    _analytics.logEvent(
      EventType.kycFlowVerifyYourIdentify,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '179',
        PropertyType.kycStatus: kycDepositStatus
      },
    );
  }

  void kycFlowCoutryOfIssueShow() {
    _analytics.logEvent(
      EventType.kycFlowCoutryOfIssueShow,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '180',
        PropertyType.kycStatus: kycDepositStatus
      },
    );
  }

  void kycFlowCoutryOfIssueSheetView() {
    _analytics.logEvent(
      EventType.kycFlowCoutryOfIssueSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '181',
        PropertyType.kycStatus: kycDepositStatus
      },
    );
  }

  void kycFlowTapContinueOnVerifyYourIdentity({
    required String country,
    required String documentList,
  }) {
    _analytics.logEvent(
      EventType.kycFlowTapContinueOnVerifyYourIdentity,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '182',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.countryKYC: country,
        PropertyType.documentList: documentList,
      },
    );
  }

  void kycFlowVerifyWait({
    required String country,
  }) {
    _analytics.logEvent(
      EventType.kycFlowVerifyWait,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '183',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.countryKYC: country,
      },
    );
  }

  void kycFlowSumsubShow({
    required String country,
  }) {
    _analytics.logEvent(
      EventType.kycFlowSumsubShow,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '184',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.countryKYC: country,
      },
    );
  }

  void kycFlowSumsubClose({
    required String country,
  }) {
    _analytics.logEvent(
      EventType.kycFlowSumsubClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '185',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.countryKYC: country,
      },
    );
  }

  void kycFlowVerifyingNowSV({
    required String country,
  }) {
    _analytics.logEvent(
      EventType.kycFlowVerifyingNowSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '186',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.countryKYC: country,
      },
    );
  }

  void kycFlowVerifyingNowPopup() {
    _analytics.logEvent(
      EventType.kycFlowVerifyingNowPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '187',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void kycFlowYouBlockedPopup() {
    _analytics.logEvent(
      EventType.kycFlowYouBlockedPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '188',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void kycFlowYouBlockedSupportTap() {
    _analytics.logEvent(
      EventType.kycFlowYouBlockedSupportTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '189',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  // SEND

  void tabOnTheSendButton({required String source}) {
    _analytics.logEvent(
      EventType.tapOnTheSendButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '80',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void sendToSheetScreenView({
    required List<AnalyticsSendMethods> sendMethods,
  }) {
    final sendMethodsCodes = <int>[];

    for (final element in sendMethods) {
      sendMethodsCodes.add(element.code);
    }

    _analytics.logEvent(
      EventType.sendToSheetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '81',
        PropertyType.sendMethodTypeAllAvailableList: sendMethodsCodes,
      },
    );
  }

  void tapOnTheGiftButton() {
    _analytics.logEvent(
      EventType.tapOnTheGiftButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '82',
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
      },
    );
  }

  void sendingAssetScreenView() {
    _analytics.logEvent(
      EventType.sendingAssetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '83',
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
      },
    );
  }

  void receiverSDetailsScreenView() {
    _analytics.logEvent(
      EventType.receiverSDetailsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '84',
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
      },
    );
  }

  void tapOnTheContinueWithReceiverSDetailsButton({
    required String giftSubmethod,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheContinueWithReceiverSDetailsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '85',
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
      },
    );
  }

  // Iban Send

  void accountTabScreenView() {
    _analytics.logEvent(
      EventType.accountTabScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '154',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void tapOnTheButtonAddBankAccount() {
    _analytics.logEvent(
      EventType.tapOnTheButtonAddBankAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '155',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void tapOnTheButtonAddAccount() {
    _analytics.logEvent(
      EventType.tapOnTheButtonAddAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '156',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void tapOnTheButtonWithAnyExistAccount() {
    _analytics.logEvent(
      EventType.tapOnTheButtonWithAnyExistAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '157',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void sendEurAmountScreenView() {
    _analytics.logEvent(
      EventType.sendEurAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '158',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void tapOnTheButtonLimitsIBAN() {
    _analytics.logEvent(
      EventType.tapOnTheButtonLimitsIBAN,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '159',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void sendLimitsIBANScreenView() {
    _analytics.logEvent(
      EventType.sendLimitsIBANScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '160',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void errorSendIBANAmount({required String errorCode}) {
    _analytics.logEvent(
      EventType.errorSendIBANAmount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '161',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
      },
    );
  }

  void tapOnTheButtonContSendIbanAmount({
    required String asset,
    required String methodType,
    required String sendAmount,
    required String preset,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonContSendIbanAmount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '162',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: methodType,
        PropertyType.sendAmount: sendAmount,
      },
    );
  }

  void sendGiftAmountScreenView({
    required String giftSubmethod,
    required String asset,
  }) {
    _analytics.logEvent(
      EventType.sendGiftAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '86',
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
      },
    );
  }

  void errorSendLimitExceeded({
    required String giftSubmethod,
    required String asset,
    required String errorText,
  }) {
    _analytics.logEvent(
      EventType.errorSendLimitExceeded,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '87',
        PropertyType.errorText: errorText,
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
      },
    );
  }

  void tapOnTheButtonContinueWithSendGiftAmountScreen({
    required String giftSubmethod,
    required String asset,
    required String totalSendAmount,
    required dynamic preset,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonContinueWithSendGiftAmountScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '88',
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
        PropertyType.totalSendAmount: totalSendAmount,
        PropertyType.preset: preset,
      },
    );
  }

  void orderSummarySendScreenView({
    required String giftSubmethod,
  }) {
    _analytics.logEvent(
      EventType.orderSummarySendScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '89',
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
      },
    );
  }

  void tapOnTheButtonConfirmSendIban({
    required String asset,
    required String methodType,
    required String sendAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonConfirmSendIban,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '164',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: methodType,
        PropertyType.sendAmount: sendAmount,
      },
    );
  }

  void tapOnTheButtonConfirmOrderSummarySend({
    required String giftSubmethod,
    required String asset,
    required String totalSendAmount,
    required String paymentFee,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonConfirmOrderSummarySend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '90',
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
        PropertyType.totalSendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
      },
    );
  }

  void confirmWithPINScreenView() {
    _analytics.logEvent(
      EventType.confirmWithPINScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '91',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void ibanConfirmWithPINScreenView({
    required String asset,
    required String methodType,
    required String sendAmount,
  }) {
    _analytics.logEvent(
      EventType.confirmWithPINScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '165',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: methodType,
        PropertyType.sendAmount: sendAmount,
      },
    );
  }

  void errorWrongPinSend({
    required String asset,
    required String methodType,
    required String sendAmount,
    required String errorCode,
  }) {
    _analytics.logEvent(
      EventType.errorWrongPinSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '166',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: methodType,
        PropertyType.sendAmount: sendAmount,
        PropertyType.errorCode: errorCode,
      },
    );
  }

  void errorWrongPin({
    required String asset,
    required String errorText,
    required AnalyticsSendMethods sendMethod,
    String? giftSubmethod,
  }) {
    _analytics.logEvent(
      EventType.errorWrongPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '92',
        PropertyType.errorText: errorText,
        PropertyType.asset: asset,
        PropertyType.sendMethodType: sendMethod.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
      },
    );
  }

  void successSendIBANScreenView({
    required String asset,
    required String methodType,
    required String sendAmount,
  }) {
    _analytics.logEvent(
      EventType.successSendIBANScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '167',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: methodType,
        PropertyType.sendAmount: sendAmount,
      },
    );
  }

  void processingSendScreenView({
    required String asset,
    required String giftSubmethod,
  }) {
    _analytics.logEvent(
      EventType.processingSendScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '93',
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
      },
    );
  }

  void failedSendIBANScreenView({
    required String asset,
    required String methodType,
    required String sendAmount,
    required String failedReason,
  }) {
    _analytics.logEvent(
      EventType.failedSendIBANScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '168',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: methodType,
        PropertyType.sendAmount: sendAmount,
      },
    );
  }

  void successSendScreenView({
    required String asset,
    required String giftSubmethod,
  }) {
    _analytics.logEvent(
      EventType.successSendScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '94',
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
      },
    );
  }

  void failedSendScreenView({
    required String asset,
    required String giftSubmethod,
    required String failedReason,
  }) {
    _analytics.logEvent(
      EventType.failedSendScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '95',
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
        PropertyType.failedReason: failedReason,
      },
    );
  }

  // Global Send

  void chooseAssetToSendScreenView() {
    _analytics.logEvent(
      EventType.chooseAssetToSendScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '135',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void shareGiftSheetScreenView() {
    _analytics.logEvent(
      EventType.shareGiftSheetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '96',
      },
    );
  }

  void destinationCountryScreenView() {
    _analytics.logEvent(
      EventType.destinationCountryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '136',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void tapOnTheButtonShareOnShareSheet() {
    _analytics.logEvent(
      EventType.tapOnTheButtonShareOnShareSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '97',
      },
    );
  }

  void paymentMethodScreenViewGlobalSend() {
    _analytics.logEvent(
      EventType.paymentMethodScreenViewGlobalSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '137',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void tapOnTheButtonCopyOnShareSheet() {
    _analytics.logEvent(
      EventType.tapOnTheButtonCopyOnShareSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '98',
      },
    );
  }

  void globalSendReceiverDetails({
    required String destCountry,
    required String paymentMethod,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendReceiverDetails,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '138',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountryName: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void tapOnTheButtonCloseOrTapInEmptyPlaceForClosingShareSheet() {
    _analytics.logEvent(
      EventType.tapOnTheButtonCloseOrTapInEmptyPlaceForClosingShareSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '99',
      },
    );
  }

  void tapOnTheButtonRemindOnSentHistoryDetailsSheet() {
    _analytics.logEvent(
      EventType.tapOnTheButtonRemindOnSentHistoryDetailsSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '100',
      },
    );
  }

  void tapOnTheButtonCancelTransactiononSentHistoryDetails() {
    _analytics.logEvent(
      EventType.tapOnTheButtonCancelTransactiononSentHistoryDetailsSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '101',
      },
    );
  }

  void tapOnTheButtonCloseOrTapOnSentHistoryDetailsSheet() {
    _analytics.logEvent(
      EventType.tapOnTheButtonCloseOrTapOnSentHistoryDetailsSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '102',
      },
    );
  }

  void claimGiftScreenView({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.claimGiftScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '105',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendTCCheckbox({
    required String destCountry,
    required String paymentMethod,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendTCCheckbox,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '139',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountryName: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void tapOnTheButtonClaimOnClaimGiftSheet({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonClaimOnClaimGiftSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '106',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendMoreDetailsButton({
    required String destCountry,
    required String paymentMethod,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendMoreDetailsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '140',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void tapOnTheButtonCloseOrTapInEmptyPlaceForClosingClaimGiftSheet({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonCloseOrTapInEmptyPlaceForClosingClaimGiftSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '107',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendMoreDetailsPopup({
    required String destCountry,
    required String paymentMethod,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendMoreDetailsPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '141',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void tapOnTheButtonRejectOnClaimGiftSheet({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonRejectOnClaimGiftSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '108',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendGotItButton({
    required String destCountry,
    required String paymentMethod,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendGotItButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '142',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void cancelClaimTransactionGiftScreenView({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.cancelClaimTransactionGiftScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '109',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendContinueReceiveDetail({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendContinueReceiveDetail,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '143',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void tapOnTheButtonYesCancelOnCancelClaimTransactionGiftPopup({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonYesCancelOnCancelClaimTransactionGiftPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '110',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendAmountScreenView({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '144',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void tapOnTheButtonNoOnCancelClaimTransactionGiftPopup({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonNoOnCancelClaimTransactionGiftPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '111',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendAmountLimitsSV({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendAmountLimitsSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '145',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void processingClaimGiftScreenView({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.processingClaimGiftScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '112',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendErrorLimit({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String errorCode,
  }) {
    _analytics.logEvent(
      EventType.globalSendErrorLimit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '146',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
      },
    );
  }

  void failedClaimGiftScreenView({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.failedClaimGiftScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '113',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void globalSendContinueAmountSc({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String totalSendAmount,
    required String preset,
  }) {
    _analytics.logEvent(
      EventType.globalSendContinueAmountSc,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '147',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.preset: preset,
      },
    );
  }

  void globalSendOrderSV({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String totalSendAmount,
  }) {
    _analytics.logEvent(
      EventType.globalSendOrderSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '148',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
      },
    );
  }

  void globalSendConfirmOrderSummary({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String totalSendAmount,
  }) {
    _analytics.logEvent(
      EventType.globalSendConfirmOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '149',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
      },
    );
  }

  void globalSendLoadingSV({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String totalSendAmount,
  }) {
    _analytics.logEvent(
      EventType.globalSendLoadingSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '150',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
      },
    );
  }

  void globalSenBioApprove({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String totalSendAmount,
  }) {
    _analytics.logEvent(
      EventType.globalSenBioApprove,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '151',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
      },
    );
  }

  void globalSendFailedSV({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String totalSendAmount,
    required String failedReason,
  }) {
    _analytics.logEvent(
      EventType.globalSendFailedSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '152',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
      },
    );
  }

  void tapOnTheButtonCloseOnFailedClaimGiftScreen({
    required String giftAmount,
    required String giftFrom,
    required String failedReason,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonCloseOnFailedClaimGiftScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '114',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
        PropertyType.failedReason: failedReason,
      },
    );
  }

  void globalSendSuccessSV({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
    required String totalSendAmount,
  }) {
    _analytics.logEvent(
      EventType.globalSendSuccessSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '153',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
      },
    );
  }

  void successClaimedGiftScreenView({
    required String giftAmount,
    required String giftFrom,
  }) {
    _analytics.logEvent(
      EventType.successClaimedGiftScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '115',
        PropertyType.giftAmount: giftAmount,
        PropertyType.giftFrom: giftFrom,
      },
    );
  }

  void orderSummarySendIBANScreenView({
    required String asset,
    required String methodType,
    required String sendAmount,
  }) {
    _analytics.logEvent(
      EventType.orderSummarySendIBANScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '163',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: methodType,
        PropertyType.sendAmount: sendAmount,
      },
    );
  }

  // Rewards

  void rewardsTapOnTheTabBar() {
    _analytics.logEvent(
      EventType.rewardsTapOnTheTabBar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '190',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void rewardsEmptyRewards() {
    _analytics.logEvent(
      EventType.rewardsEmptyRewards,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '191',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void rewardsMainScreenView({
    required int rewardsToClaim,
    required String totalReceiveSum,
    required List<String> assetList,
  }) {
    _analytics.logEvent(
      EventType.rewardsMainScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '192',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.rewardsToClaim: rewardsToClaim,
        PropertyType.totalReceiveSum: totalReceiveSum,
        PropertyType.activeRewardsAssets: assetList.toList(),
      },
    );
  }

  void rewardsClickOpenReward({
    required int rewardsToClaim,
  }) {
    _analytics.logEvent(
      EventType.rewardsClickOpenReward,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '193',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.rewardsToClaim: rewardsToClaim,
      },
    );
  }

  void rewardsChooseRewardCard({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.rewardsChooseRewardCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '194',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void rewardsOpenRewardClose({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.rewardsOpenRewardClose,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '195',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void rewardsOpenRewardTapCard({
    required int cardNumber,
    required String source,
  }) {
    _analytics.logEvent(
      EventType.rewardsOpenRewardTapCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '196',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
        PropertyType.cardNumber: cardNumber,
      },
    );
  }

  void rewardsOpenCardProcesing({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.rewardsOpenCardProcesing,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '197',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void rewardsCardFlipSuccess({
    required String winAsset,
    required String winAmount,
    required String source,
    required String rewardToClaime,
  }) {
    _analytics.logEvent(
      EventType.rewardsCardFlipSuccess,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '198',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
        PropertyType.rewardsToClaim: rewardToClaime,
        PropertyType.winAsset: winAsset,
        PropertyType.winAmount: winAmount,
      },
    );
  }

  void rewardsCloseFlowAfterCardFlip({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.rewardsCloseFlowAfterCardFlip,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '199',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void rewardsCardShare({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.rewardsCardShare,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '200',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void rewardsClickNextReward({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.rewardsClickNextReward,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '201',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
      },
    );
  }

  void rewardsClickOnReward({
    required String transferAseet,
    required String transferAmount,
  }) {
    _analytics.logEvent(
      EventType.rewardsClickOnReward,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '202',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.transferAseet: transferAseet,
        PropertyType.transferAmount: transferAmount,
      },
    );
  }

  void rewardsRewardTransferPopup({
    required String transferAseet,
    required String transferAmount,
  }) {
    _analytics.logEvent(
      EventType.rewardsRewardTransferPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '203',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.transferAseet: transferAseet,
        PropertyType.transferAmount: transferAmount,
      },
    );
  }

  void rewardsTransferPopupClickTransfer({
    required String transferAseet,
    required String transferAmount,
  }) {
    _analytics.logEvent(
      EventType.rewardsTransferPopupClickTransfer,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '204',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.transferAseet: transferAseet,
        PropertyType.transferAmount: transferAmount,
      },
    );
  }

  void rewardsTransferPopupClickCancel({
    required String transferAseet,
    required String transferAmount,
  }) {
    _analytics.logEvent(
      EventType.rewardsTransferPopupClickCancel,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '205',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.transferAseet: transferAseet,
        PropertyType.transferAmount: transferAmount,
      },
    );
  }

  void rewardsSuccessRewardTransfer({
    required String transferAseet,
    required String transferAmount,
  }) {
    _analytics.logEvent(
      EventType.rewardsSuccessRewardTransfer,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '206',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.transferAseet: transferAseet,
        PropertyType.transferAmount: transferAmount,
      },
    );
  }

  void rewardsSuccessTransferGotItClick({
    required String transferAseet,
    required String transferAmount,
  }) {
    _analytics.logEvent(
      EventType.rewardsSuccessTransferGotItClick,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '207',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.transferAseet: transferAseet,
        PropertyType.transferAmount: transferAmount,
      },
    );
  }

  void rewardsClickShare() {
    _analytics.logEvent(
      EventType.rewardsClickShare,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '208',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void walletsScreenView({
    required List<String> favouritesAssetsList,
  }) {
    _analytics.logEvent(
      EventType.walletsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.favouritesAssetsList: favouritesAssetsList,
        PropertyType.eventId: '256',
      },
    );
  }

  void tapOnTheButtonProfileOnWalletsScreen() {
    _analytics.logEvent(
      EventType.tapOnTheButtonProfileOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '257',
      },
    );
  }

  void tapOnTheButtonShowHideBalancesOnWalletsScreen({
    required bool isShowNow,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonShowHideBalancesOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.isShowNow: isShowNow,
        PropertyType.eventId: '258',
      },
    );
  }

  void tapOnTheTabWalletsInTabBar() {
    _analytics.logEvent(
      EventType.tapOnTheTabWalletsInTabBar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '259',
      },
    );
  }

  void tapOnTheButtonPendingTransactionsOnWalletsScreen({
    required int numberOfPendingTrx,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonPendingTransactionsOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.numberOfPendingTrx: numberOfPendingTrx,
        PropertyType.eventId: '260',
      },
    );
  }

  void tapOnFavouriteWalletOnWalletsScreen({
    required String openedAsset,
  }) {
    _analytics.logEvent(
      EventType.tapOnFavouriteWalletOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.openedAsset: openedAsset,
        PropertyType.eventId: '261',
      },
    );
  }

  void tapOnTheButtonAddWalletOnWalletsScreen() {
    _analytics.logEvent(
      EventType.tapOnTheButtonAddWalletOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '262',
      },
    );
  }

  void addWalletForFavouritesScreenView() {
    _analytics.logEvent(
      EventType.tapOnTheButtonAddWalletOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '263',
      },
    );
  }

  void tapOnTheButtonCloseOnAddWalletForFavouritesSheet() {
    _analytics.logEvent(
      EventType.tapOnTheButtonCloseOnAddWalletForFavouritesSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '264',
      },
    );
  }

  void tapOnAssetForAddToFavouritesOnAddWalletForFavouritesSheet({
    required String addedFavouritesAssetName,
  }) {
    _analytics.logEvent(
      EventType.tapOnAssetForAddToFavouritesOnAddWalletForFavouritesSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.addedFavouritesAssetName: addedFavouritesAssetName,
        PropertyType.eventId: '265',
      },
    );
  }

  void tapOnTheDeleteButtonOnTheWalletScreen() {
    _analytics.logEvent(
      EventType.tapOnTheDeleteButtonOnTheWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '266',
      },
    );
  }

  void tapOnTheButtonDoneForChangeWalletsOrderOnTheWalletScreen() {
    _analytics.logEvent(
      EventType.tapOnTheButtonDoneForChangeWalletsOrderOnTheWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '267',
      },
    );
  }

  void tapOnTheButtonGetAccountEUROnAddWalletForFavouritesSheet() {
    _analytics.logEvent(
      EventType.tapOnTheButtonGetAccountEUROnAddWalletForFavouritesSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '268',
      },
    );
  }

  void cryptoFavouriteWalletScreen({
    required String openedAsset,
  }) {
    _analytics.logEvent(
      EventType.cryptoFavouriteWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.openedAsset: openedAsset,
        PropertyType.eventId: '283',
      },
    );
  }

  void tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen({
    required String openedAsset,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.openedAsset: openedAsset,
        PropertyType.eventId: '284',
      },
    );
  }

  void swipeHistoryListOnCryptoFavouriteWalletScreen({
    required String openedAsset,
  }) {
    _analytics.logEvent(
      EventType.swipeHistoryListOnCryptoFavouriteWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.openedAsset: openedAsset,
        PropertyType.eventId: '285',
      },
    );
  }

  void tapOnTheButtonAnyHistoryTrxOnCryptoFavouriteWalletScreen({
    required String openedAsset,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonAnyHistoryTrxOnCryptoFavouriteWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.openedAsset: openedAsset,
        PropertyType.eventId: '298',
      },
    );
  }

  void globalTransactionHistoryScreenView({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventType.globalTransactionHistoryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '299',
      },
    );
  }

  void tapOnTheButtonAllOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonAllOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '300',
      },
    );
  }

  void tapOnTheButtonPendingOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonPendingOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '301',
      },
    );
  }

  void swipeHistoryListOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventType.swipeHistoryListOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '302',
      },
    );
  }

  void tapOnTheButtonAnyHistoryTrxOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonAnyHistoryTrxOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '303',
      },
    );
  }

  void tapOnTheButtonBackOnGlobalTransactionHistoryScreen ({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonBackOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '304',
      },
    );
  }
}
