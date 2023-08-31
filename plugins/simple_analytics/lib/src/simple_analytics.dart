import 'package:amplitude_flutter/amplitude.dart';

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

  void setKYCDepositStatus(int status) {
    kycDepositStatus = status;
  }

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

  void kycFlowCoutryOfIssueCont({
    required String country,
    required String documentList,
  }) {
    _analytics.logEvent(
      EventType.kycFlowCoutryOfIssueCont,
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

  void tapOnTheSendButton({
    required String source,
  }) {
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
    required List<String> methods,
  }) {
    _analytics.logEvent(
      EventType.sendToSheetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '81',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.sendMethodsList: methods,
      },
    );
  }

  void tapOnTheGiftButton({
    required String type,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheGiftButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '82',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.sendMethodsType: type,
      },
    );
  }

  void sendingAssetScreenView({
    required String type,
  }) {
    _analytics.logEvent(
      EventType.sendingAssetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '83',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.sendMethodsType: type,
      },
    );
  }

  void receiversDetailsScreenView({
    required String type,
  }) {
    _analytics.logEvent(
      EventType.receiversDetailsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '84',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.sendMethodsType: type,
      },
    );
  }

  void tapOnTheContWithReceiverDetailsButton({
    required String type,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheContWithReceiverDetailsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '85',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.sendMethodsType: type,
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
        PropertyType.preset: preset,
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

  void confirmWithPINScreenView({
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

  void globalSendErrorLimit({
    required String destCountry,
    required String paymentMethod,
    required String globalSendType,
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventType.globalSendErrorLimit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '146',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.destinationCountry: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
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
}
