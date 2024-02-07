// ignore_for_file: lines_longer_than_80_chars

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

  // ignore: use_setters_to_change_properties
  void updateisTechAcc({required bool techAcc}) {
    isTechAcc = techAcc;
  }

  /// Sign Up & Sign In Flow

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
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void kycFlowProvideInformation() {
    _analytics.logEvent(
      EventType.kycFlowProvideInformation,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '178',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void kycFlowVerifyYourIdentify() {
    _analytics.logEvent(
      EventType.kycFlowVerifyYourIdentify,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '179',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void kycFlowCoutryOfIssueShow() {
    _analytics.logEvent(
      EventType.kycFlowCoutryOfIssueShow,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '180',
        PropertyType.kycStatus: kycDepositStatus,
      },
    );
  }

  void kycFlowCoutryOfIssueSheetView() {
    _analytics.logEvent(
      EventType.kycFlowCoutryOfIssueSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '181',
        PropertyType.kycStatus: kycDepositStatus,
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
        PropertyType.eventId: '91',
        PropertyType.kycStatus: kycDepositStatus,
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
      EventType.addWalletForFavouritesScreenView,
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

  void tapOnTheButtonGetAccountEUROnWalletsScreen() {
    _analytics.logEvent(
      EventType.tapOnTheButtonGetAccountEUROnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '268',
      },
    );
  }

  void eurWalletVerifyYourAccount() {
    _analytics.logEvent(
      EventType.eurWalletVerifyYourAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '269',
      },
    );
  }

  void eurWalletTapOnVerifyAccount() {
    _analytics.logEvent(
      EventType.eurWalletTapOnVerifyAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '270',
      },
    );
  }

  void eurWalletShowUpdateAddressInfo() {
    _analytics.logEvent(
      EventType.eurWalletShowUpdateAddressInfo,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '271',
      },
    );
  }

  void eurWalletTapContinueOnAdreeInfo() {
    _analytics.logEvent(
      EventType.eurWalletTapContinueOnAdreeInfo,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '272',
      },
    );
  }

  void eurWalletShowToastLestCreateAccount() {
    _analytics.logEvent(
      EventType.eurWalletShowToastLestCreateAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '273',
      },
    );
  }

  void eurWalletAccountScreen(int numberOfEurAccounts) {
    _analytics.logEvent(
      EventType.eurWalletAccountScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '274',
        PropertyType.numberOfOpenedEurAccounts: numberOfEurAccounts,
      },
    );
  }

  void eurWalletSwipeBetweenWallets() {
    _analytics.logEvent(
      EventType.eurWalletSwipeBetweenWallets,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '276',
      },
    );
  }

  void eurWalletAddAccountEur() {
    _analytics.logEvent(
      EventType.eurWalletAddAccountEur,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '277',
      },
    );
  }

  void eurWalletPersonalEURAccount() {
    _analytics.logEvent(
      EventType.eurWalletPersonalEURAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '278',
      },
    );
  }

  void eurWalletBackOnPersonalAccount() {
    _analytics.logEvent(
      EventType.eurWalletBackOnPersonalAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '279',
      },
    );
  }

  void eurWalletTapOnContinuePersonalEUR() {
    _analytics.logEvent(
      EventType.eurWalletTapOnContinuePersonalEUR,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '280',
      },
    );
  }

  void eurWalletPleasePassVerificaton() {
    _analytics.logEvent(
      EventType.eurWalletPleasePassVerificaton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '281',
      },
    );
  }

  void eurWalletVerifyAccountPartnerSide() {
    _analytics.logEvent(
      EventType.eurWalletVerifyAccountPartnerSide,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '282',
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

  void eurWalletEURAccountWallet({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventType.eurWalletEURAccountWallet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '286',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
      },
    );
  }

  void eurWalletTapBackOnAccountWalletScreen({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventType.eurWalletTapBackOnAccountWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '287',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
      },
    );
  }

  void eurWalletTapEditEURAccointScreen({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventType.eurWalletTapEditEURAccointScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '288',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
      },
    );
  }

  void eurWalletEditLabelScreen() {
    _analytics.logEvent(
      EventType.eurWalletEditLabelScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '289',
      },
    );
  }

  void eurWalletTapSaveChanges() {
    _analytics.logEvent(
      EventType.eurWalletTapSaveChanges,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '290',
      },
    );
  }

  void eurWalletDepositDetailsSheet({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
    required String source,
  }) {
    _analytics.logEvent(
      EventType.eurWalletDepositDetailsSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '292',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.source: source,
      },
    );
  }

  void eurWalletTapCloseOnDeposirSheet({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventType.eurWalletTapCloseOnDeposirSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '293',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
      },
    );
  }

  void eurWalletTapCopyDeposit({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
    required String copyType,
  }) {
    _analytics.logEvent(
      EventType.eurWalletTapCopyDeposit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '294',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.copyType: copyType,
      },
    );
  }

  void eurWalletSwipeHistoryListEURAccount() {
    _analytics.logEvent(
      EventType.eurWalletSwipeHistoryListEURAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '295',
      },
    );
  }

  void eurWalletWithdrawEURAccountScreen({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
    required String copyType,
  }) {
    _analytics.logEvent(
      EventType.eurWalletWithdrawEURAccountScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '296',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.copyType: copyType,
      },
    );
  }

  void eurWalletTapAnyHistoryTRXEUR({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventType.eurWalletTapAnyHistoryTRXEUR,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '297',
        PropertyType.eurAccountType: isCJ ? 'CJ' : 'Unlimint',
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
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

  void tapOnTheButtonBackOnGlobalTransactionHistoryScreen({
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

  void pinAfterWaiting({
    required int timeAfterBlock,
  }) {
    _analytics.logEvent(
      EventType.pinAfterWaiting,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.timeAfterBlock: timeAfterBlock,
        PropertyType.eventId: '305',
      },
    );
  }

  //

  void eurWithdrawTapOnTheButtonWithdraw({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapOnTheButtonWithdraw,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '398',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawBankTransferWithEurSheet({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawBankTransferWithEurSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '399',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawUserTapsOnButtonEdit({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawUserTapsOnButtonEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '400',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawEditBankAccountWithSV({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawEditBankAccountWithSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '401',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapSaveChangesEdit({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapSaveChangesEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '402',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapCloseEdit({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapCloseEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '403',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapDeleteEdit({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapDeleteEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '404',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapConfirmDeleteEdit({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapConfirmDeleteEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '405',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapReceive({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapReceive,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '406',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapExistingAccount({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapExistingAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '407',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawAddReceiving({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawAddReceiving,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '408',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapBackReceiving({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapBackReceiving,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '409',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawTapContinueAddReceiving({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapContinueAddReceiving,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '410',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
      },
    );
  }

  void eurWithdrawEurAmountSV({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawEurAmountSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '411',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
      },
    );
  }

  void eurWithdrawBackAmountSV({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawBackAmountSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '412',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
      },
    );
  }

  void eurWithdrawErrorShowConvert({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String errorText,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawErrorShowConvert,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '413',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.errorText: errorText,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawContinueFromAmoountB({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawContinueFromAmoountB,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '414',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawReferenceSV({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawReferenceSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '424',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawContinueReferecenceButton({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
    required String referenceText,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawContinueReferecenceButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '425',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.referenceText: referenceText,
      },
    );
  }

  void tapOnTheButtonAddCashWalletsOnWalletsScreen() {
    _analytics.logEvent(
      EventType.tapOnTheButtonAddCashWalletsOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '426',
      },
    );
  }

  void eurWithdrawWithdrawOrderSummarySV({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawWithdrawOrderSummarySV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '415',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawTapBackOrderSummary({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapBackOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '416',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawProcessingFeePopup({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawProcessingFeePopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '417',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawTapConfirmOrderSummary({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawTapConfirmOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '418',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawSuccessWithdrawEndSV({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawSuccessWithdrawEndSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '419',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void eurWithdrawFailed({
    required String eurAccountType,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.eurWithdrawFailed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '420',
        PropertyType.eurAccountFromType: eurAccountType,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  //Buy flow

  void tapOnTheBuyWalletButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheBuyWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '313',
        PropertyType.source: source,
      },
    );
  }

  void errorBuyIsUnavailable() {
    _analytics.logEvent(
      EventType.errorBuyIsUnavailable,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '314',
      },
    );
  }

  void chooseWalletScreenView() {
    _analytics.logEvent(
      EventType.chooseWalletScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '315',
      },
    );
  }

  void tapOnTheBackFromChooseWalletButton() {
    _analytics.logEvent(
      EventType.tapOnTheBackFromChooseWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '316',
      },
    );
  }

  void tapOnTheAnyWalletForBuyButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheAnyWalletForBuyButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '317',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void addCardDetailsScreenView({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.addCardDetailsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '318',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void tapOnSaveCardForFurtherPurchaseButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.tapOnSaveCardForFurtherPurchaseButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '319',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void tapOnContinueCrNewCardButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.tapOnContinueCrNewCardButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '320',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void addACustomNameScreenView({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.addACustomNameScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '321',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void tapOnTheBackFromCardLabelCreationButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheBackFromCardLabelCreationButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '322',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void tapOnTheContinueSaveCardLabelButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheContinueSaveCardLabelButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '323',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void payWithPMSheetView({
    required String destinationWallet,
    List<String> listOfAvailablePMs = const [],
  }) {
    _analytics.logEvent(
      EventType.payWithPMSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '324',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.listOfAvailablePMs: listOfAvailablePMs,
      },
    );
  }

  void tapOnTheButtonCloseForClosingSheetOnPayWithPMSheet({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonCloseForClosingSheetOnPayWithPMSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '325',
        PropertyType.destinationWallet: destinationWallet,
      },
    );
  }

  void tapOnTheButtonSomePMForBuyOnPayWithPMSheet({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonSomePMForBuyOnPayWithPMSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '326',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
      },
    );
  }

  void buyAmountScreenView({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
  }) {
    _analytics.logEvent(
      EventType.buyAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '327',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
      },
    );
  }

  void tapOnTheBackFromAmountScreenButton({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheBackFromAmountScreenButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '328',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
      },
    );
  }

  void tapOnTheChangeInputBuyButton({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required NowInputType nowInput,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheChangeInputBuyButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '329',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.nowInput: nowInput.name,
      },
    );
  }

  void tapOnTheChooseAssetButton({
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheChooseAssetButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '330',
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
      },
    );
  }

  void tapOnThePayWithButton({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
  }) {
    _analytics.logEvent(
      EventType.tapOnThePayWithButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '331',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
      },
    );
  }

  void tapOnTheContinueWithBuyAmountButton({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheContinueWithBuyAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '332',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void buyOrderSummaryScreenView({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.buyOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '333',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void tapToAgreeToTheTCAndPrivacyPolicyBuy({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
    required bool isCheckboxNowTrue,
  }) {
    _analytics.logEvent(
      EventType.tapToAgreeToTheTCAndPrivacyPolicyBuy,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '334',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
        PropertyType.isCheckboxNowTrue: isCheckboxNowTrue,
      },
    );
  }

  void tapOnTheButtonPaymentFeeInfoOnBuyCheckout() {
    _analytics.logEvent(
      EventType.tapOnTheButtonPaymentFeeInfoOnBuyCheckout,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '335',
      },
    );
  }

  void paymentProcessingFeePopupView({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
    required FeeType feeType,
  }) {
    _analytics.logEvent(
      EventType.paymentProcessingFeePopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '336',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
        PropertyType.type: feeType.name,
      },
    );
  }

  void tapOnTheCloseOnPPopap({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
    required FeeType feeType,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheCloseOnPPopap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '337',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
        PropertyType.type: feeType.name,
      },
    );
  }

  void tapOnTheButtonConfirmOnBuyOrderSummary({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonConfirmOnBuyOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '338',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void tapOnTheButtonTermsAndConditionsOnBuyOrderSummary({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonTermsAndConditionsOnBuyOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '339',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void tapOnTheButtonPrivacyPolicyOnBuyOrderSummary({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonPrivacyPolicyOnBuyOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '340',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void enterCVVForBuyScreenView({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.enterCVVForBuyScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '341',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void tapOnTheCloseOnCVVPopup({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheCloseOnCVVPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '342',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void threeDSecureScreenView({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.threeDSecureScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '343',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void tapOnTheCloseButtonOn3DSecureScreen({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheCloseButtonOn3DSecureScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '344',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void successBuyEndScreenView({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.successBuyEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '345',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void tapOnTheCloseButtonOnSuccessBuyEndScreen({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheCloseButtonOnSuccessBuyEndScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '346',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void failedBuyEndScreenView({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.failedBuyEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '347',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void tapOnTheCloseButtonOnFailedBuyEndScreen({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
    required String sourceBuyAmount,
    required String destinationBuyAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheCloseButtonOnFailedBuyEndScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '348',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.sourceCurrency: sourceCurrency,
        PropertyType.sourceBuyAmount: sourceBuyAmount,
        PropertyType.destinationBuyAmount: destinationBuyAmount,
      },
    );
  }

  void unsupportedCurrencyPopupView() {
    _analytics.logEvent(
      EventType.unsupportedCurrencyPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '349',
      },
    );
  }

  void tapOnTheGotItButtonOnUnsupportedCurrencyScreen() {
    _analytics.logEvent(
      EventType.tapOnTheGotItButtonOnUnsupportedCurrencyScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '350',
      },
    );
  }

  void tapOnTheBuyButtonOnBSCSegmentScreen() {
    _analytics.logEvent(
      EventType.tapOnTheBuyButtonOnBSCSegmentScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '421',
      },
    );
  }

  void tapOnTheSellButtonOnBSCSegmentButton() {
    _analytics.logEvent(
      EventType.tapOnTheSellButtonOnBSCSegmentButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '422',
      },
    );
  }

  void tapOnTheConvertButtonOnBSCSegmentButton() {
    _analytics.logEvent(
      EventType.tapOnTheConvertButtonOnBSCSegmentButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '423',
      },
    );
  }

  void tapOnTheSellButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheSellButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '351',
        PropertyType.source: source,
      },
    );
  }

  // Sell flow

  void tapOnTheSellAll() {
    _analytics.logEvent(
      EventType.tapOnTheSellAll,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '352',
      },
    );
  }

  void tapOnTheChangeCurrencySell() {
    _analytics.logEvent(
      EventType.tapOnTheChangeCurrencySell,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '353',
      },
    );
  }

  void sellAmountScreenView() {
    _analytics.logEvent(
      EventType.sellAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '354',
      },
    );
  }

  void tapOnTheSellFromButton({
    required String currentFromValueForSell,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheSellFromButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '355',
        PropertyType.currentFromValueForSell: currentFromValueForSell,
      },
    );
  }

  void sellFromSheetView() {
    _analytics.logEvent(
      EventType.sellFromSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '356',
      },
    );
  }

  void tapOnCloseSheetFromSellButton() {
    _analytics.logEvent(
      EventType.tapOnCloseSheetFromSellButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '357',
      },
    );
  }

  void tapOnSelectedNewSellFromAssetButton({
    required String newSellFromAsset,
  }) {
    _analytics.logEvent(
      EventType.tapOnSelectedNewSellFromAssetButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '358',
        PropertyType.newSellFromAsset: newSellFromAsset,
      },
    );
  }

  void tapOnTheSellToButton({
    required String currentToValueForSell,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheSellToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '359',
        PropertyType.currentToValueForSell: currentToValueForSell,
      },
    );
  }

  void sellToSheetView() {
    _analytics.logEvent(
      EventType.sellToSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '360',
      },
    );
  }

  void tapOnCloseSheetSellToButton() {
    _analytics.logEvent(
      EventType.tapOnCloseSheetSellToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '361',
      },
    );
  }

  void tapOnSelectedNewSellToButton({
    required String newSellToMethod,
  }) {
    _analytics.logEvent(
      EventType.tapOnSelectedNewSellToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '362',
        PropertyType.newSellToMethod: newSellToMethod,
      },
    );
  }

  void errorYouNeedToCreateEURAccountFirst() {
    _analytics.logEvent(
      EventType.errorYouNeedToCreateEURAccountFirst,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '364',
      },
    );
  }

  void errorShowingErrorUnderSellAmount() {
    _analytics.logEvent(
      EventType.errorShowingErrorUnderSellAmount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '365',
      },
    );
  }

  void tapOnTheBackFromSellAmountButton() {
    _analytics.logEvent(
      EventType.tapOnTheBackFromSellAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '366',
      },
    );
  }

  void tapOnTheContinueWithSellAmountButton({
    required String destinationWallet,
    required String nowInput,
    required String sellFromWallet,
    required PaymenthMethodType sellToPMType,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheContinueWithSellAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '367',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.nowInput: nowInput,
        PropertyType.sellFromWallet: sellFromWallet,
        PropertyType.sellToPMType: sellToPMType.name,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void sellOrderSummaryScreenView({
    required String destinationWallet,
    required String cryptoAmount,
    required String fiatAmount,
    required String sellFromWallet,
    required PaymenthMethodType sellToPMType,
    required String fiatAccountLabel,
  }) {
    _analytics.logEvent(
      EventType.sellOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '368',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.cryptoAmount: cryptoAmount,
        PropertyType.fiatAmount: fiatAmount,
        PropertyType.sellFromWallet: sellFromWallet,
        PropertyType.sellToPMType: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
      },
    );
  }

  void tapOnTheBackFromSellConfirmationButton() {
    _analytics.logEvent(
      EventType.tapOnTheBackFromSellConfirmationButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '369',
      },
    );
  }

  void tapToAgreeToTheTCAndPrivacyPolicySell() {
    _analytics.logEvent(
      EventType.tapToAgreeToTheTCAndPrivacyPolicySell,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '370',
      },
    );
  }

  void paymentProcessingFeeSellPopupView({
    required FeeType feeType,
  }) {
    _analytics.logEvent(
      EventType.paymentProcessingFeeSellPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '371',
        PropertyType.type: feeType.name,
      },
    );
  }

  void tapOnTheButtonConfirmOnSellOrderSummary({
    required String destinationWallet,
    required String cryptoAmount,
    required String fiatAmount,
    required String sellFromWallet,
    required PaymenthMethodType sellToPMType,
    required String fiatAccountLabel,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonConfirmOnSellOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '372',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.cryptoAmount: cryptoAmount,
        PropertyType.fiatAmount: fiatAmount,
        PropertyType.sellFromWallet: sellFromWallet,
        PropertyType.sellToPMType: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
      },
    );
  }

  void successSellEndScreenView({
    required String destinationWallet,
    required String cryptoAmount,
    required String fiatAmount,
    required String sellFromWallet,
    required PaymenthMethodType sellToPMType,
    required String fiatAccountLabel,
  }) {
    _analytics.logEvent(
      EventType.successSellEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '373',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.cryptoAmount: cryptoAmount,
        PropertyType.fiatAmount: fiatAmount,
        PropertyType.sellFromWallet: sellFromWallet,
        PropertyType.sellToPMType: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
      },
    );
  }

  void failedSellEndScreenView({
    required String destinationWallet,
    required String cryptoAmount,
    required String fiatAmount,
    required String sellFromWallet,
    required PaymenthMethodType sellToPMType,
    required String fiatAccountLabel,
  }) {
    _analytics.logEvent(
      EventType.failedSellEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '374',
        PropertyType.destinationWallet: destinationWallet,
        PropertyType.cryptoAmount: cryptoAmount,
        PropertyType.fiatAmount: fiatAmount,
        PropertyType.sellFromWallet: sellFromWallet,
        PropertyType.sellToPMType: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
      },
    );
  }

  // Convert flow

  void tapOnTheConvertButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheConvertButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '375',
        PropertyType.source: source,
      },
    );
  }

  void tapOnTheConvertAll() {
    _analytics.logEvent(
      EventType.tapOnTheConvertAll,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '376',
      },
    );
  }

  void tapOnTheChangeInputAssetConvert() {
    _analytics.logEvent(
      EventType.tapOnTheChangeInputAssetConvert,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '377',
      },
    );
  }

  void convertAmountScreenView() {
    _analytics.logEvent(
      EventType.convertAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '378',
      },
    );
  }

  void tapOnTheConvertFromButton({
    required String currentFromValueForSell,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheConvertFromButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '379',
        PropertyType.currentFromValueForSell: currentFromValueForSell,
      },
    );
  }

  void convertFromSheetView() {
    _analytics.logEvent(
      EventType.convertFromSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '380',
      },
    );
  }

  void tapOnCloseSheetConvertFromButton() {
    _analytics.logEvent(
      EventType.tapOnCloseSheetConvertFromButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '381',
      },
    );
  }

  void tapOnSelectedNewConvertFromAssetButton({
    required String newConvertFromAsset,
  }) {
    _analytics.logEvent(
      EventType.tapOnSelectedNewConvertFromAssetButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '382',
        PropertyType.newConvertFromAsset: newConvertFromAsset,
      },
    );
  }

  void tapOnTheConvertToButton({
    required String currentToValueForConvert,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheConvertToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '383',
        PropertyType.currentToValueForConvert: currentToValueForConvert,
      },
    );
  }

  void convertToSheetView() {
    _analytics.logEvent(
      EventType.convertToSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '384',
      },
    );
  }

  void tapOnCloseSheetConvertToButton() {
    _analytics.logEvent(
      EventType.tapOnCloseSheetConvertToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '385',
      },
    );
  }

  void tapOnSelectedNewConvertToButton({
    required String newConvertToAsset,
  }) {
    _analytics.logEvent(
      EventType.tapOnSelectedNewConvertToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '386',
        PropertyType.newConvertToAsset: newConvertToAsset,
      },
    );
  }

  void errorYourCryptoBalanceIsZeroPleaseGetCryptoFirst() {
    _analytics.logEvent(
      EventType.errorYourCryptoBalanceIsZeroPleaseGetCryptoFirst,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '387',
      },
    );
  }

  void errorShowingErrorUnderConvertAmount({
    required String errorText,
  }) {
    _analytics.logEvent(
      EventType.errorShowingErrorUnderConvertAmount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '389',
        PropertyType.errorText: errorText,
      },
    );
  }

  void tapOnTheBackFromConvertAmountButton() {
    _analytics.logEvent(
      EventType.tapOnTheBackFromConvertAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '390',
      },
    );
  }

  void tapOnTContinueWithConvertAmountCutton({
    required String enteredAmount,
    required String convertFromAsset,
    required String convertToAsset,
    required String nowInput,
  }) {
    _analytics.logEvent(
      EventType.tapOnTContinueWithConvertAmountCutton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '391',
        PropertyType.convertFromAsset: convertFromAsset,
        PropertyType.convertToAsset: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void convertOrderSummaryScreenView({
    required String enteredAmount,
    required String convertFromAsset,
    required String convertToAsset,
    required String nowInput,
  }) {
    _analytics.logEvent(
      EventType.convertOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '392',
        PropertyType.convertFromAsset: convertFromAsset,
        PropertyType.convertToAsset: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void tapOnTheBackFromCovertOrderSummaryButton() {
    _analytics.logEvent(
      EventType.tapOnTheBackFromCovertOrderSummaryButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '393',
      },
    );
  }

  void processingFeeConvertPopupView() {
    _analytics.logEvent(
      EventType.processingFeeConvertPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '394',
      },
    );
  }

  void tapOnTheButtonConfirmOnConvertOrderSummary({
    required String enteredAmount,
    required String convertFromAsset,
    required String convertToAsset,
    required String nowInput,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheButtonConfirmOnConvertOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '395',
        PropertyType.convertFromAsset: convertFromAsset,
        PropertyType.convertToAsset: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void successConvertEndScreenView({
    required String enteredAmount,
    required String convertFromAsset,
    required String convertToAsset,
    required String nowInput,
  }) {
    _analytics.logEvent(
      EventType.successConvertEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '396',
        PropertyType.convertFromAsset: convertFromAsset,
        PropertyType.convertToAsset: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void failedConvertEndScreenView({
    required String enteredAmount,
    required String convertFromAsset,
    required String convertToAsset,
    required String nowInput,
  }) {
    _analytics.logEvent(
      EventType.failedConvertEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '397',
        PropertyType.convertFromAsset: convertFromAsset,
        PropertyType.convertToAsset: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  // Simple card
  void viewGetSimpleCard() {
    _analytics.logEvent(
      EventType.viewGetSimpleCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '429',
      },
    );
  }
  
  void tapOnGetSimpleCard({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.tapOnGetSimpleCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '430',
        PropertyType.source: source,
      },
    );
  }
  
  void viewCardTypeSheet() {
    _analytics.logEvent(
      EventType.viewCardTypeSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '431',
      },
    );
  }
  
  void tapOnVirtualCard() {
    _analytics.logEvent(
      EventType.tapOnVirtualCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '432',
      },
    );
  }
  
  void confirmWithPinView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.confirmWithPinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '433',
        PropertyType.cardID: cardID,
      },
    );
  }
  
  void viewSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.viewSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '434',
        PropertyType.cardID: cardID,
      },
    );
  }
  
  void tapCloseSetUpPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapCloseSetUpPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '435',
        PropertyType.cardID: cardID,
      },
    );
  }
  
  void tapHideSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapHideSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '436',
        PropertyType.cardID: cardID,
      },
    );
  }
  
  void tapShowSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapShowSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '437',
        PropertyType.cardID: cardID,
      },
    );
  }
  
  void tapContinueSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapContinueSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '438',
        PropertyType.cardID: cardID,
      },
    );
  }
  
  void viewCompleteKYCForCard() {
    _analytics.logEvent(
      EventType.viewCompleteKYCForCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '439',
      },
    );
  }
  
  void tapVerifyAccountForCard() {
    _analytics.logEvent(
      EventType.tapVerifyAccountForCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '440',
      },
    );
  }
  
  void tapCancelKYCForCard() {
    _analytics.logEvent(
      EventType.tapCancelKYCForCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '441',
      },
    );
  }
  
  void viewPleaseWaitLoading() {
    _analytics.logEvent(
      EventType.viewPleaseWaitLoading,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '442',
      },
    );
  }
  
  void viewKYCSumsubCreation() {
    _analytics.logEvent(
      EventType.viewKYCSumsubCreation,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '443',
      },
    );
  }
  
  void viewWorkingOnYourCard() {
    _analytics.logEvent(
      EventType.viewWorkingOnYourCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '444',
      },
    );
  }
  
  void viewCardIsReady() {
    _analytics.logEvent(
      EventType.viewCardIsReady,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '445',
      },
    );
  }
  
  void viewEURWalletWithoutButton() {
    _analytics.logEvent(
      EventType.viewEURWalletWithoutButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '446',
      },
    );
  }
  
  void viewEURWalletWithButton() {
    _analytics.logEvent(
      EventType.viewEURWalletWithButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '447',
      },
    );
  }

  void tapOnSimpleCard() {
    _analytics.logEvent(
      EventType.tapOnSimpleCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '448',
      },
    );
  }

  void viewVirtualCardScreen({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.viewVirtualCardScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '449',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapShowCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapShowCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '450',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapHideCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapHideCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '451',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapCopyCardNumber({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapCopyCardNumber,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '452',
        PropertyType.cardID: cardID,
      },
    );
  }

  void viewErrorOnCardScreen({
    required String cardID,
    required String reason,
  }) {
    _analytics.logEvent(
      EventType.viewErrorOnCardScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '453',
        PropertyType.cardID: cardID,
        PropertyType.reason: reason,
      },
    );
  }

  void tapBackFromVirualCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapBackFromVirualCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '454',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapFreezeCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapFreezeCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '455',
        PropertyType.cardID: cardID,
      },
    );
  }

  void viewFreezeCardPopup({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.viewFreezeCardPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '456',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapConfirmFreezeCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapConfirmFreezeCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '457',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapCancelFreeze({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapCancelFreeze,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '458',
        PropertyType.cardID: cardID,
      },
    );
  }

  void viewFrozenCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.viewFrozenCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '459',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnUnfreeze({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnUnfreeze,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '460',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnAddCash({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnAddCash,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '469',
        PropertyType.cardID: cardID,
      },
    );
  }

  void viewAddCashSheet({
    required String cardID,
    required String assets,
  }) {
    _analytics.logEvent(
      EventType.viewAddCashSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '470',
        PropertyType.cardID: cardID,
        PropertyType.availableAssetsList: assets,
      },
    );
  }

  void tapOnAddCashFromAsset({
    required String cardID,
    required String asset,
  }) {
    _analytics.logEvent(
      EventType.tapOnAddCashFromAsset,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '471',
        PropertyType.cardID: cardID,
        PropertyType.asset: asset,
      },
    );
  }

  void viewErrorOnSellScreen({
    required String cardID,
    required String reason,
  }) {
    _analytics.logEvent(
      EventType.viewErrorOnSellScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '472',
        PropertyType.cardID: cardID,
        PropertyType.reason: reason,
      },
    );
  }

  void tapOnSettings({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnSettings,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '473',
        PropertyType.cardID: cardID,
      },
    );
  }

  void viewCardSettings({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.viewCardSettings,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '474',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnRemindPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnRemindPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '475',
        PropertyType.cardID: cardID,
      },
    );
  }

  void viewRemindPinSheet({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.viewRemindPinSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '476',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnCancelRemindPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnCancelRemindPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '477',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapInContinueRemindPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapInContinueRemindPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '478',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnSetPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnSetPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '479',
        PropertyType.cardID: cardID,
      },
    );
  }

  void viewConfirmWithPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.viewConfirmWithPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '480',
        PropertyType.cardID: cardID,
      },
    );
  }

  // Terminate Simple card
  void tapOnTheTerminateButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheTerminateButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '461',
        PropertyType.cardID: cardID,
      },
    );
  }

  void terminateWithBalancePopupScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.terminateWithBalancePopupScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '462',
        PropertyType.cardID: cardID,
      },
    );
  }

  void approveTerminatePopupScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.approveTerminatePopupScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '463',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnTheCancelTerminateButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheCancelTerminateButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '464',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnTheConfirmTerminateButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheConfirmTerminateButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '465',
        PropertyType.cardID: cardID,
      },
    );
  }

  void confirmTerminateWithPinScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.confirmTerminateWithPinScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '466',
        PropertyType.cardID: cardID,
      },
    );
  }

  void pleaseWaitLoaderOnCardTerminateLoadingView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.pleaseWaitLoaderOnCardTerminateLoadingView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '467',
        PropertyType.cardID: cardID,
      },
    );
  }

  void theCardHasBeenTerminateToastView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.theCardHasBeenTerminateToastView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '468',
        PropertyType.cardID: cardID,
      },
    );
  }

  //Limits Simple Card
  void tapOnTheSpendingVirtualCardLimitsButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheSpendingVirtualCardLimitsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '481',
        PropertyType.cardID: cardID,
      },
    );
  }

  void spendingVirtualCardLimitsScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.spendingVirtualCardLimitsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '482',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnTheBackFromSpendingVirtualCardLimitsButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheBackFromSpendingVirtualCardLimitsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '483',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnAddRefCodeButton() {
    _analytics.logEvent(
      EventType.tapOnAddRefCodeButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '306',
      },
    );
  }

  void enterReferralCodeScreenView() {
    _analytics.logEvent(
      EventType.enterReferralCodeScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '307',
      },
    );
  }

  void tapOnPasteButtonOnEnterReferralCode() {
    _analytics.logEvent(
      EventType.tapOnPasteButtonOnEnterReferralCode,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '308',
      },
    );
  }

  void validReferralCodeScreenView() {
    _analytics.logEvent(
      EventType.validReferralCodeScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '309',
      },
    );
  }

  void errorInvalidReferralCode() {
    _analytics.logEvent(
      EventType.errorInvalidReferralCode,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '310',
      },
    );
  }

  void tapOnContinueButtonOnEnterReferralCode() {
    _analytics.logEvent(
      EventType.tapOnContinueButtonOnEnterReferralCode,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '311',
      },
    );
  }

  void tapOnDeleteRefCodeButton() {
    _analytics.logEvent(
      EventType.tapOnDeleteRefCodeButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '312',
      },
    );
  }

  void onboardingFinanceIsSimpleScreenView() {
    _analytics.logEvent(
      EventType.onboardingFinanceIsSimpleScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '489',
      },
    );
  }

  void onboardingCryptoIsSimpleScreenView() {
    _analytics.logEvent(
      EventType.onboardingCryptoIsSimpleScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '490',
      },
    );
  }

  void onboardingSendMoneyGloballyScreenView() {
    _analytics.logEvent(
      EventType.onboardingSendMoneyGloballyScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '491',
      },
    );
  }

  void tapOnTheOnboardingGetStartedButton() {
    _analytics.logEvent(
      EventType.tapOnTheOnboardingGetStartedButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '492',
      },
    );
  }

  // Edit Simple card lable
  void tapOnTheEditVirtualCardLabelButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheEditVirtualCardLabelButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '484',
        PropertyType.cardID: cardID,
      },
    );
  }

  void editVirtualCardLabelScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.editVirtualCardLabelScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '485',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnTheBackFromEditVirtualCardLabelButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheBackFromEditVirtualCardLabelButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '486',
        PropertyType.cardID: cardID,
      },
    );
  }

  void tapOnTheSaveChangesFromEditVirtualCardLabelButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheSaveChangesFromEditVirtualCardLabelButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '487',
        PropertyType.cardID: cardID,
      },
    );
  }

  // Transfer flow

  void tapOnTheDepositButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '498',
        PropertyType.source: source,
      },
    );
  }

  void errorDepositIsUnavailable() {
    _analytics.logEvent(
      EventType.errorDepositIsUnavailable,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '499',
      },
    );
  }

  void depositToScreenView() {
    _analytics.logEvent(
      EventType.depositToScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '500',
      },
    );
  }

  void tapOnAnyEurAccountOnDepositButton({
    required String accountType,
  }) {
    _analytics.logEvent(
      EventType.tapOnAnyEurAccountOnDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '501',
        PropertyType.accountType: accountType,
      },
    );
  }

  void depositByScreenView() {
    _analytics.logEvent(
      EventType.depositByScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '502',
      },
    );
  }

  void tapOnTheAnyAccountForDepositButton({
    required String accountType,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheAnyAccountForDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '503',
        PropertyType.accountType: accountType,
      },
    );
  }

  void addCashFromTrScreenView() {
    _analytics.logEvent(
      EventType.addCashFromTrScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '504',
      },
    );
  }

  void tapOnTheAnyCryptoForDepositButton({
    required String cryptoAsset,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheAnyCryptoForDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '505',
        PropertyType.cryptoAsset: cryptoAsset,
      },
    );
  }

  void transferAmountScreenView({
    required String sourceTransfer,
  }) {
    _analytics.logEvent(
      EventType.transferAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '506',
        PropertyType.sourceTransfer: sourceTransfer,
      },
    );
  }

  void tapOnTheTransferFromButton({
    required String currentFromValueForTransfer,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheTransferFromButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '507',
        PropertyType.currentFromValueForTransfer: currentFromValueForTransfer,
      },
    );
  }

  void transferFromSheetView() {
    _analytics.logEvent(
      EventType.transferFromSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '508',
      },
    );
  }

  void tapOnSelectedNewTransferFromAccountButton({
    required String newTransferFromAccount,
  }) {
    _analytics.logEvent(
      EventType.tapOnSelectedNewTransferFromAccountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '509',
        PropertyType.newTransferFromAccount: newTransferFromAccount,
      },
    );
  }

  void tapOnTheTransferToButton({
    required String currentToValueForTransfer,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheTransferToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '510',
        PropertyType.currentToValueForTransfer: currentToValueForTransfer,
      },
    );
  }

  void transferToSheetView() {
    _analytics.logEvent(
      EventType.transferToSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '511',
      },
    );
  }

  void tapOnSelectedNewTransferToButton({
    required String newTransferToAccount,
  }) {
    _analytics.logEvent(
      EventType.tapOnSelectedNewTransferToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '512',
        PropertyType.newTransferToAccount: newTransferToAccount,
      },
    );
  }

  void tapOnTheBackFromTransferAmountButton() {
    _analytics.logEvent(
      EventType.tapOnTheBackFromTransferAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '513',
      },
    );
  }

  void tapOnTheContinueWithTransferAmountButton({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheContinueWithTransferAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '514',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void transferOrderSummaryScreenView({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.transferOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '515',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void tapOnTheBackFromTransferOrderSummaryButton({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.tapOnTheBackFromTransferOrderSummaryButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '516',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void tapAnTheButtonConfirmOnTransferOrderSummary({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.tapAnTheButtonConfirmOnTransferOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '517',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void successTransferEndScreenView({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.successTransferEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '518',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  void failedTransferEndScreenView({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventType.failedTransferEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '519',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.enteredAmount: enteredAmount,
      },
    );
  }

  //

  void pushNotificationSV() {
    _analytics.logEvent(
      EventType.pushNotificationSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '493',
      },
    );
  }

  void pushNotificationButtonTap() {
    _analytics.logEvent(
      EventType.pushNotificationButtonTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '494',
      },
    );
  }

  void pushNotificationAlertView() {
    _analytics.logEvent(
      EventType.pushNotificationAlertView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '495',
      },
    );
  }

  void pushNotificationAgree() {
    _analytics.logEvent(
      EventType.pushNotificationAgree,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '496',
      },
    );
  }

  void pushNotificationDisagree() {
    _analytics.logEvent(
      EventType.pushNotificationDisagree,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '497',
      },
    );
  }
}
