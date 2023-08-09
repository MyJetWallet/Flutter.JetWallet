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
      },
    );
  }

  void signInFlowTapGetStarted() {
    _analytics.logEvent(
      EventType.signInFlowTapGetStarted,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '36',
      },
    );
  }

  void signInFlowEnterEmailView() {
    _analytics.logEvent(
      EventType.signInFlowEnterEmailView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '37',
      },
    );
  }

  void signInFlowEmailVerificationView() {
    _analytics.logEvent(
      EventType.signInFlowEmailVerificationView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '40',
      },
    );
  }

  void signInFlowPhoneNumberView() {
    _analytics.logEvent(
      EventType.signInFlowPhoneNumberView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '47',
      },
    );
  }

  void signInFlowPersonalDetailsView() {
    _analytics.logEvent(
      EventType.signInFlowPersonalDetailsView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '52',
      },
    );
  }

  void signInFlowDateSheetView() {
    _analytics.logEvent(
      EventType.signInFlowDateSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '53',
      },
    );
  }

  void signInFlowSelectCountryView() {
    _analytics.logEvent(
      EventType.signInFlowSelectCountryView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '55',
      },
    );
  }

  void signInFlowCreatePinView() {
    _analytics.logEvent(
      EventType.signInFlowCreatePinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '63',
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
      },
    );
  }

  void signInFlowVerificationPassed() {
    _analytics.logEvent(
      EventType.signInFlowVerificationPassed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '73',
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
}
