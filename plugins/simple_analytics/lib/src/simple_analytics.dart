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

  void tabOnTheSendButton({required String source}) {
    _analytics.logEvent(
      EventType.tapOnTheSendButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '80',
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
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '91',
      },
    );
  }

  void errorWrongPin({
    required String asset,
    required String giftSubmethod,
    required String errorText,
  }) {
    _analytics.logEvent(
      EventType.errorWrongPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '92',
        PropertyType.errorText: errorText,
        PropertyType.asset: asset,
        PropertyType.sendMethodType: AnalyticsSendMethods.gift.code,
        PropertyType.giftSendSubmethod: giftSubmethod,
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

  void tapOnTheButtonCancelTransactiononSentHistoryDetailsSheet() {
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
}
