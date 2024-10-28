// ignore_for_file: lines_longer_than_80_chars

import '../simple_analytics.dart';
import 'models/event_category.dart';
import 'models/event_name.dart';
import 'models/event_type.dart';
import 'models/property_type.dart';

const _simpleAccountText = 'Simple account';
const _personalAccountText = 'Personal account';
const _accountTypeSimple = 'Simple';
const _accountTypePersonal = 'Personal';

final sAnalytics = SimpleAnalytics();

class SimpleAnalytics {
  factory SimpleAnalytics() => _instance;

  SimpleAnalytics._internal();

  static final SimpleAnalytics _instance = SimpleAnalytics._internal();

  final _analytics = SendEventsService();

  bool isTechAcc = false;
  bool newBuyZeroScreenViewSent = false;
  int kycDepositStatus = 0;

  /// Run at the start of the app
  ///
  /// Provide:
  /// 1. environmentKey for Amplitude workspace
  /// 2. userEmail if user is already authenticated
  /// 3. logEventFunc for send events to other apis
  Future<void> init({
    required String environmentKey,
    required bool techAcc,
    required LogEventFunc logEventFunc,
    String? userEmail,
    bool useAmplitude = true,
    bool allowedSendEventsToAmplitude = true,
  }) async {
    await _analytics.init(
      environmentKey,
      logEventFunc: logEventFunc,
      useAmplitude: useAmplitude,
      allowedSendEventsToAmplitude: allowedSendEventsToAmplitude,
    );

    if (userEmail != null) {
      await _analytics.setUserId(userEmail.toLowerCase());
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

  void updateLogEventFunc(LogEventFunc logEventFunc) {
    _analytics.updateLogEventFunc(logEventFunc);
  }

  /// Sign Up & Sign In Flow

  void signInFlowEnterEmailView() {
    _analytics.logEvent(
      EventName.signInFlowEnterEmailView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '37',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowEmailContinue() {
    _analytics.logEvent(
      EventName.signInFlowEmailContinue,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '39',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowEmailVerificationView() {
    _analytics.logEvent(
      EventName.signInFlowEmailVerificationView,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '40',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowErrorVerificationCode() {
    _analytics.logEvent(
      EventName.signInFlowErrorVerificationCode,
      eventProperties: {
        PropertyType.techAcc: 'none',
        PropertyType.eventId: '46',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowPhoneNumberView() {
    _analytics.logEvent(
      EventName.signInFlowPhoneNumberView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '47',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowPhoneNumberContinue() {
    _analytics.logEvent(
      EventName.signInFlowPhoneNumberContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '48',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowPhoneConfirmView() {
    _analytics.logEvent(
      EventName.signInFlowPhoneConfirmView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '49',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowPhoneReceiveCodePhoneCall() {
    _analytics.logEvent(
      EventName.signInFlowPhoneReceiveCodePhoneCall,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '50',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowPhoneConfirmWrongPhone({required String errorCode}) {
    _analytics.logEvent(
      EventName.signInFlowPhoneConfirmWrongPhone,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '51',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowPersonalDetailsView() {
    _analytics.logEvent(
      EventName.signInFlowPersonalDetailsView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '52',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void signInFlowSelectCountryView() {
    _analytics.logEvent(
      EventName.signInFlowSelectCountryView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '55',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void signInFlowErrorCountryBlocked({required String erroCode}) {
    _analytics.logEvent(
      EventName.signInFlowErrorCountryBlocked,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '56',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: erroCode,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void signInFlowPersonalContinue() {
    _analytics.logEvent(
      EventName.signInFlowPersonalContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '57',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void signInFlowCreatePinView() {
    _analytics.logEvent(
      EventName.signInFlowCreatePinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '63',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void signInFlowConfirmPinView() {
    _analytics.logEvent(
      EventName.signInFlowConfirmPinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '64',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void signInFlowErrorPin({
    required String error,
  }) {
    _analytics.logEvent(
      EventName.signInFlowErrorPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '65',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: error,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void signInFlowEnableBiometricView({
    required String biometric,
  }) {
    _analytics.logEvent(
      EventName.signInFlowEnableBiometricView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '66',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.biometric: biometric,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  void signInFlowEnterPinView() {
    _analytics.logEvent(
      EventName.signInFlowEnterPinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '72',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signIn.id,
      },
    );
  }

  void signInFlowVerificationPassed() {
    _analytics.logEvent(
      EventName.signInFlowVerificationPassed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '73',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void verificationProfileScreenView() {
    _analytics.logEvent(
      EventName.verificationProfileScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '116',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void verificationProfileLogout() {
    _analytics.logEvent(
      EventName.verificationProfileLogout,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '117',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void verificationProfileProvideInfo() {
    _analytics.logEvent(
      EventName.verificationProfileProvideInfo,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '118',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  void verificationProfileCreatePIN() {
    _analytics.logEvent(
      EventName.verificationProfileCreatePIN,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '119',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.signUp.id,
      },
    );
  }

  // Crypto wallet send

  void cryptoSendChooseAssetScreenView({
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendChooseAssetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '120',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void cryptoSendSendAssetNameScreenView({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendSendAssetNameScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '121',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void cryptoSendChooseNetworkScreenView({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendChooseNetworkScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '122',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void cryptoSendTapQr({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendTapQr,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '123',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void cryptoSendTapPaste({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendTapPaste,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '124',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void cryptoSendTapContinue({
    required String asset,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendTapContinue,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '125',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void cryptoSendAssetNameAmountScreenView({
    required String asset,
    required String network,
    required String sendMethodType,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendAssetNameAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '126',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.cryptoSendErrorLimit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '127',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void cryptoSendTapContinueAmountScreen({
    required String asset,
    required String network,
    required String sendMethodType,
    required String totalSendAmount,
  }) {
    _analytics.logEvent(
      EventName.cryptoSendTapContinueAmountScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '128',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.cryptoSendOrderSummarySend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '129',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.cryptoSendTapConfirmOrder,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '130',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.cryptoSendLoadingOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '131',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.cryptoSendBioApprove,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '132',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.cryptoSendFailedSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '133',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
        PropertyType.errorCode: failedReason,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.cryptoSendSuccessSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '134',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.paymentFee: paymentFee,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  // Receive flow 169-176

  void tapOnTheReceiveButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheReceiveButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '169',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.source: source,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  void chooseAssetToReceiveScreenView() {
    _analytics.logEvent(
      EventName.chooseAssetToReceiveScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '170',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  void chooseNetworkPopupView({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.chooseNetworkPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '171',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  void receiveAssetScreenView({
    required String asset,
    required String network,
  }) {
    _analytics.logEvent(
      EventName.receiveAssetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '172',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  void tapOnTheButtonNetworkOnReceiveAssetScreen({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonNetworkOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '173',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  void chooseNetworkPopupViewShowedOnReceiveAssetScreen({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.chooseNetworkPopupViewShowedOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '174',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  void tapOnTheButtonCopyOnReceiveAssetScreen({
    required String asset,
    required String network,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonCopyOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '175',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  void tapOnTheButtonShareOnReceiveAssetScreen({
    required String asset,
    required String network,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonShareOnReceiveAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '176',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.receiveFlow.id,
      },
    );
  }

  // KYC

  void kycFlowVerificationScreenView() {
    _analytics.logEvent(
      EventName.kycFlowVerificationScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '177',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.kyc.id,
      },
    );
  }

  void kycFlowProvideInformation() {
    _analytics.logEvent(
      EventName.kycFlowProvideInformation,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '178',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.kyc.id,
      },
    );
  }

  void kycFlowVerifyWait({
    required String country,
  }) {
    _analytics.logEvent(
      EventName.kycFlowVerifyWait,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '183',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: country,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.kyc.id,
      },
    );
  }

  void kycFlowVerifyingNowSV({
    required String country,
  }) {
    _analytics.logEvent(
      EventName.kycFlowVerifyingNowSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '186',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: country,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.kyc.id,
      },
    );
  }

  void kycFlowVerifyingNowPopup() {
    _analytics.logEvent(
      EventName.kycFlowVerifyingNowPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '187',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.kyc.id,
      },
    );
  }

  void kycFlowYouBlockedPopup() {
    _analytics.logEvent(
      EventName.kycFlowYouBlockedPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '188',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.kyc.id,
      },
    );
  }

  // Global Send

  void chooseAssetToSendScreenView() {
    _analytics.logEvent(
      EventName.chooseAssetToSendScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '135',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void destinationCountryScreenView() {
    _analytics.logEvent(
      EventName.destinationCountryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '136',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  void paymentMethodScreenViewGlobalSend() {
    _analytics.logEvent(
      EventName.paymentMethodScreenViewGlobalSend,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '137',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendReceiverDetails,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '138',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendTCCheckbox,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '139',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendMoreDetailsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '140',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendMoreDetailsPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '141',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendGotItButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '142',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendContinueReceiveDetail,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '143',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '144',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendAmountLimitsSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '145',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendErrorLimit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '146',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.errorCode: errorCode,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
  }) {
    _analytics.logEvent(
      EventName.globalSendContinueAmountSc,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '147',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendOrderSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '148',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendConfirmOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '149',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendLoadingSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '150',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSenBioApprove,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '151',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendFailedSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '152',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.errorCode: failedReason,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
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
      EventName.globalSendSuccessSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.eventId: '153',
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.country: destCountry,
        PropertyType.paymentMethod: paymentMethod,
        PropertyType.globalMethods: globalSendType,
        PropertyType.asset: asset,
        PropertyType.sendMethodsType: sendMethodType,
        PropertyType.sendAmount: totalSendAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sendFlow.id,
      },
    );
  }

  // wallet screen with favourites assets

  void walletsScreenView({
    required List<String> favouritesAssetsList,
  }) {
    _analytics.logEvent(
      EventName.walletsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.favouritesAssetsList: favouritesAssetsList,
        PropertyType.eventId: '256',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheTabWalletsInTabBar() {
    _analytics.logEvent(
      EventName.tapOnTheTabWalletsInTabBar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '259',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonPendingTransactionsOnWalletsScreen({
    required int numberOfPendingTrx,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonPendingTransactionsOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.numberOfPendingTrx: numberOfPendingTrx,
        PropertyType.eventId: '260',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnFavouriteWalletOnWalletsScreen({
    required String openedAsset,
  }) {
    _analytics.logEvent(
      EventName.tapOnFavouriteWalletOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: openedAsset,
        PropertyType.eventId: '261',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonAddWalletOnWalletsScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonAddWalletOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '262',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void addWalletForFavouritesScreenView() {
    _analytics.logEvent(
      EventName.addWalletForFavouritesScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '263',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnAssetForAddToFavouritesOnAddWalletForFavouritesSheet({
    required String addedFavouritesAssetName,
  }) {
    _analytics.logEvent(
      EventName.tapOnAssetForAddToFavouritesOnAddWalletForFavouritesSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: addedFavouritesAssetName,
        PropertyType.eventId: '265',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheDeleteButtonOnTheWalletScreen() {
    _analytics.logEvent(
      EventName.tapOnTheDeleteButtonOnTheWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '266',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonDoneForChangeWalletsOrderOnTheWalletScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonDoneForChangeWalletsOrderOnTheWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '267',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonGetAccountEUROnWalletsScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonGetAccountEUROnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '268',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletVerifyYourAccount() {
    _analytics.logEvent(
      EventName.eurWalletVerifyYourAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '269',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletTapOnVerifyAccount() {
    _analytics.logEvent(
      EventName.eurWalletTapOnVerifyAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '270',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletShowToastLestCreateAccount() {
    _analytics.logEvent(
      EventName.eurWalletShowToastLestCreateAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '273',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletAccountScreen(int numberOfEurAccounts) {
    _analytics.logEvent(
      EventName.eurWalletAccountScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '274',
        PropertyType.numberOfOpenedEurAccounts: numberOfEurAccounts,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletAddAccountEur() {
    _analytics.logEvent(
      EventName.eurWalletAddAccountEur,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '277',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletPersonalEURAccount() {
    _analytics.logEvent(
      EventName.eurWalletPersonalEURAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '278',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletBackOnPersonalAccount() {
    _analytics.logEvent(
      EventName.eurWalletBackOnPersonalAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '279',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletTapOnContinuePersonalEUR() {
    _analytics.logEvent(
      EventName.eurWalletTapOnContinuePersonalEUR,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '280',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletPleasePassVerificaton() {
    _analytics.logEvent(
      EventName.eurWalletPleasePassVerificaton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '281',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletVerifyAccountPartnerSide() {
    _analytics.logEvent(
      EventName.eurWalletVerifyAccountPartnerSide,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '282',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletEURAccountWallet({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventName.eurWalletEURAccountWallet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '286',
        PropertyType.eurAccountType: isCJ ? _accountTypeSimple : _accountTypePersonal,
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
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
      EventName.eurWalletDepositDetailsSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '292',
        PropertyType.eurAccountType: isCJ ? _accountTypeSimple : _accountTypePersonal,
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.source: source,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletTapCloseOnDeposirSheet({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventName.eurWalletTapCloseOnDeposirSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '293',
        PropertyType.eurAccountType: isCJ ? _accountTypeSimple : _accountTypePersonal,
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
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
      EventName.eurWalletTapCopyDeposit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '294',
        PropertyType.eurAccountType: isCJ ? _accountTypeSimple : _accountTypePersonal,
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.copyType: copyType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void eurWalletTapAnyHistoryTRXEUR({
    required bool isCJ,
    required String eurAccountLabel,
    required bool isHasTransaction,
  }) {
    _analytics.logEvent(
      EventName.eurWalletTapAnyHistoryTRXEUR,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '297',
        PropertyType.eurAccountType: isCJ ? _accountTypeSimple : _accountTypePersonal,
        PropertyType.eurAccountLabel: eurAccountLabel,
        PropertyType.isHasTransactions: isHasTransaction,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonAnyHistoryTrxOnCryptoFavouriteWalletScreen({
    required String openedAsset,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonAnyHistoryTrxOnCryptoFavouriteWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.asset: openedAsset,
        PropertyType.eventId: '298',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void globalTransactionHistoryScreenView({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventName.globalTransactionHistoryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '299',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonAllOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonAllOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '300',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonPendingOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonPendingOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '301',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonAnyHistoryTrxOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonAnyHistoryTrxOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '303',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void tapOnTheButtonBackOnGlobalTransactionHistoryScreen({
    required GlobalHistoryTab globalHistoryTab,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonBackOnGlobalTransactionHistoryScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.globalHistoryTab: globalHistoryTab.name,
        PropertyType.eventId: '304',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.walletWithFavourites.id,
      },
    );
  }

  void pinAfterWaiting({
    required int timeAfterBlock,
  }) {
    _analytics.logEvent(
      EventName.pinAfterWaiting,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.timeAfterBlock: timeAfterBlock,
        PropertyType.eventId: '305',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.signUpSignIn.id,
      },
    );
  }

  //

  void eurWithdrawTapOnTheButtonWithdraw({
    required String accountIban,
    required String accountLabel,
    required bool isCJ,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapOnTheButtonWithdraw,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '398',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawBankTransferWithEurSheet({
    required bool isCJAccount,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawBankTransferWithEurSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '399',
        PropertyType.accountFrom: isCJAccount ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawUserTapsOnButtonEdit({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawUserTapsOnButtonEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '400',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawEditBankAccountWithSV({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawEditBankAccountWithSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '401',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapSaveChangesEdit({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapSaveChangesEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '402',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapCloseEdit({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapCloseEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '403',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapDeleteEdit({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapDeleteEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '404',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapConfirmDeleteEdit({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapConfirmDeleteEdit,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '405',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapReceive({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapReceive,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '406',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapExistingAccount({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapExistingAccount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '407',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawAddReceiving({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawAddReceiving,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '408',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapBackReceiving({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapBackReceiving,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '409',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapContinueAddReceiving({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapContinueAddReceiving,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '410',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawEurAmountSV({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawEurAmountSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '411',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawBackAmountSV({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawBackAmountSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '412',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawErrorShowConvert({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String errorText,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawErrorShowConvert,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '413',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.errorCode: errorText,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawContinueFromAmoountB({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawContinueFromAmoountB,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '414',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawReferenceSV({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawReferenceSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '424',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawContinueReferecenceButton({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
    required String referenceText,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawContinueReferecenceButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '425',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.referenceText: referenceText,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void tapOnTheButtonAddCashWalletsOnWalletsScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonAddCashWalletsOnWalletsScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '426',
      },
    );
  }

  void eurWithdrawWithdrawOrderSummarySV({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawWithdrawOrderSummarySV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '415',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapBackOrderSummary({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapBackOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '416',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawTapConfirmOrderSummary({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawTapConfirmOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '418',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawSuccessWithdrawEndSV({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawSuccessWithdrawEndSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '419',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  void eurWithdrawFailed({
    required bool isCJ,
    required String accountIban,
    required String accountLabel,
    required String eurAccType,
    required String eurAccLabel,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.eurWithdrawFailed,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '420',
        PropertyType.accountFrom: isCJ ? _simpleAccountText : _personalAccountText,
        PropertyType.eurAccountFromIBAN: accountIban,
        PropertyType.eurAccountFromLabel: accountLabel,
        PropertyType.eurAccountType: eurAccType,
        PropertyType.eurAccountLabel: eurAccLabel,
        PropertyType.enteredAmount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawal.id,
      },
    );
  }

  //Buy flow

  void tapOnTheBuyWalletButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheBuyWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '313',
        PropertyType.source: source,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void errorBuyIsUnavailable() {
    _analytics.logEvent(
      EventName.errorBuyIsUnavailable,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '314',
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void chooseWalletScreenView() {
    _analytics.logEvent(
      EventName.chooseWalletScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '315',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheAnyWalletForBuyButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheAnyWalletForBuyButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '317',
        PropertyType.asset: destinationWallet,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void addCardDetailsScreenView({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventName.addCardDetailsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '318',
        PropertyType.asset: destinationWallet,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnSaveCardForFurtherPurchaseButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventName.tapOnSaveCardForFurtherPurchaseButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '319',
        PropertyType.asset: destinationWallet,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnContinueCrNewCardButton({
    required String destinationWallet,
  }) {
    _analytics.logEvent(
      EventName.tapOnContinueCrNewCardButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '320',
        PropertyType.asset: destinationWallet,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void payWithPMSheetView({
    required String destinationWallet,
    List<String> listOfAvailablePMs = const [],
  }) {
    _analytics.logEvent(
      EventName.payWithPMSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '324',
        PropertyType.asset: destinationWallet,
        PropertyType.listOfAvailablePMs: listOfAvailablePMs,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheButtonSomePMForBuyOnPayWithPMSheet({
    required String destinationWallet,
    required PaymenthMethodType pmType,
    required String buyPM,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonSomePMForBuyOnPayWithPMSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '326',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.buyAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '327',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.tapOnTheBackFromAmountScreenButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '328',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.tapOnTheChangeInputBuyButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '329',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.nowInput: nowInput.name,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheChooseAssetButton({
    required PaymenthMethodType pmType,
    required String buyPM,
    required String sourceCurrency,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheChooseAssetButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '330',
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.tapOnThePayWithButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '331',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.tapOnTheContinueWithBuyAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '332',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.amountInFiat: sourceBuyAmount,
        PropertyType.amountInCrypto: destinationBuyAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.buyOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '333',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.amountInFiat: sourceBuyAmount,
        PropertyType.amountInCrypto: destinationBuyAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheButtonPaymentFeeInfoOnBuyCheckout() {
    _analytics.logEvent(
      EventName.tapOnTheButtonPaymentFeeInfoOnBuyCheckout,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '335',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.paymentProcessingFeePopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '336',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.amountInFiat: sourceBuyAmount,
        PropertyType.amountInCrypto: destinationBuyAmount,
        PropertyType.type: feeType.name,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.tapOnTheButtonConfirmOnBuyOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '338',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.amountInFiat: sourceBuyAmount,
        PropertyType.amountInCrypto: destinationBuyAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.successBuyEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '345',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.amountInFiat: sourceBuyAmount,
        PropertyType.amountInCrypto: destinationBuyAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
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
      EventName.failedBuyEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '347',
        PropertyType.asset: destinationWallet,
        PropertyType.pmType: pmType.name,
        PropertyType.buyPM: buyPM,
        PropertyType.currency: sourceCurrency,
        PropertyType.amountInFiat: sourceBuyAmount,
        PropertyType.amountInCrypto: destinationBuyAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheBuyButtonOnBSCSegmentScreen() {
    _analytics.logEvent(
      EventName.tapOnTheBuyButtonOnBSCSegmentScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '421',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheSellButtonOnBSCSegmentButton() {
    _analytics.logEvent(
      EventName.tapOnTheSellButtonOnBSCSegmentButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '422',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheConvertButtonOnBSCSegmentButton() {
    _analytics.logEvent(
      EventName.tapOnTheConvertButtonOnBSCSegmentButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '423',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnTheSellButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheSellButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '351',
        PropertyType.source: source,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  // Sell flow

  void tapOnTheSellAll() {
    _analytics.logEvent(
      EventName.tapOnTheSellAll,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '352',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void tapOnTheChangeCurrencySell() {
    _analytics.logEvent(
      EventName.tapOnTheChangeCurrencySell,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '353',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void sellAmountScreenView() {
    _analytics.logEvent(
      EventName.sellAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '354',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void tapOnTheSellFromButton({
    required String currentFromValueForSell,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheSellFromButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '355',
        PropertyType.assetFrom: currentFromValueForSell,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void sellFromSheetView() {
    _analytics.logEvent(
      EventName.sellFromSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '356',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void tapOnSelectedNewSellFromAssetButton({
    required String newSellFromAsset,
  }) {
    _analytics.logEvent(
      EventName.tapOnSelectedNewSellFromAssetButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '358',
        PropertyType.assetFrom: newSellFromAsset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void tapOnTheSellToButton({
    required bool currentToValueForSell,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheSellToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '359',
        PropertyType.sellTo: currentToValueForSell ? _simpleAccountText : _personalAccountText,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void sellToSheetView() {
    _analytics.logEvent(
      EventName.sellToSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '360',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void tapOnSelectedNewSellToButton({
    required String newSellToMethod,
  }) {
    _analytics.logEvent(
      EventName.tapOnSelectedNewSellToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '362',
        PropertyType.sellTo: newSellToMethod,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void errorYouNeedToCreateEURAccountFirst() {
    _analytics.logEvent(
      EventName.errorYouNeedToCreateEURAccountFirst,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '364',
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void errorShowingErrorUnderSellAmount() {
    _analytics.logEvent(
      EventName.errorShowingErrorUnderSellAmount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '365',
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void tapOnTheBackFromSellAmountButton() {
    _analytics.logEvent(
      EventName.tapOnTheBackFromSellAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '366',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
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
      EventName.tapOnTheContinueWithSellAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '367',
        PropertyType.currency: destinationWallet,
        PropertyType.nowInput: nowInput,
        PropertyType.assetFrom: sellFromWallet,
        PropertyType.sellTo: sellToPMType.name,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
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
      EventName.sellOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '368',
        PropertyType.currency: destinationWallet,
        PropertyType.amountInCrypto: cryptoAmount,
        PropertyType.amountInFiat: fiatAmount,
        PropertyType.assetFrom: sellFromWallet,
        PropertyType.sellTo: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void tapOnTheBackFromSellConfirmationButton() {
    _analytics.logEvent(
      EventName.tapOnTheBackFromSellConfirmationButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '369',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  void paymentProcessingFeeSellPopupView({
    required FeeType feeType,
  }) {
    _analytics.logEvent(
      EventName.paymentProcessingFeeSellPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '371',
        PropertyType.type: feeType.name,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
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
      EventName.tapOnTheButtonConfirmOnSellOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '372',
        PropertyType.currency: destinationWallet,
        PropertyType.amountInCrypto: cryptoAmount,
        PropertyType.amountInFiat: fiatAmount,
        PropertyType.assetFrom: sellFromWallet,
        PropertyType.sellTo: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
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
      EventName.successSellEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '373',
        PropertyType.currency: destinationWallet,
        PropertyType.amountInCrypto: cryptoAmount,
        PropertyType.amountInFiat: fiatAmount,
        PropertyType.assetFrom: sellFromWallet,
        PropertyType.sellTo: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
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
      EventName.failedSellEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '374',
        PropertyType.currency: destinationWallet,
        PropertyType.amountInCrypto: cryptoAmount,
        PropertyType.amountInFiat: fiatAmount,
        PropertyType.assetFrom: sellFromWallet,
        PropertyType.sellTo: sellToPMType.name,
        PropertyType.fiatAccountLabel: fiatAccountLabel,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  // Convert flow

  void tapOnTheConvertButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheConvertButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '375',
        PropertyType.source: source,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void tapOnTheConvertAll() {
    _analytics.logEvent(
      EventName.tapOnTheConvertAll,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '376',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void tapOnTheChangeInputAssetConvert() {
    _analytics.logEvent(
      EventName.tapOnTheChangeInputAssetConvert,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '377',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void convertAmountScreenView() {
    _analytics.logEvent(
      EventName.convertAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '378',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void tapOnTheConvertFromButton({
    required String currentFromValueForSell,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheConvertFromButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '379',
        PropertyType.assetFrom: currentFromValueForSell,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void convertFromSheetView() {
    _analytics.logEvent(
      EventName.convertFromSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '380',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void tapOnSelectedNewConvertFromAssetButton({
    required String newConvertFromAsset,
  }) {
    _analytics.logEvent(
      EventName.tapOnSelectedNewConvertFromAssetButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '382',
        PropertyType.assetFrom: newConvertFromAsset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void tapOnTheConvertToButton({
    required String currentToValueForConvert,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheConvertToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '383',
        PropertyType.assetTo: currentToValueForConvert,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void convertToSheetView() {
    _analytics.logEvent(
      EventName.convertToSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '384',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void tapOnCloseSheetConvertToButton() {
    _analytics.logEvent(
      EventName.tapOnCloseSheetConvertToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '385',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void tapOnSelectedNewConvertToButton({
    required String newConvertToAsset,
  }) {
    _analytics.logEvent(
      EventName.tapOnSelectedNewConvertToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '386',
        PropertyType.assetTo: newConvertToAsset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void errorYourCryptoBalanceIsZeroPleaseGetCryptoFirst() {
    _analytics.logEvent(
      EventName.errorYourCryptoBalanceIsZeroPleaseGetCryptoFirst,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '387',
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void errorShowingErrorUnderConvertAmount({
    required String errorText,
  }) {
    _analytics.logEvent(
      EventName.errorShowingErrorUnderConvertAmount,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '389',
        PropertyType.errorCode: errorText,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
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
      EventName.tapOnTContinueWithConvertAmountCutton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '391',
        PropertyType.assetFrom: convertFromAsset,
        PropertyType.assetTo: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
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
      EventName.convertOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '392',
        PropertyType.assetFrom: convertFromAsset,
        PropertyType.assetTo: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void processingFeeConvertPopupView() {
    _analytics.logEvent(
      EventName.processingFeeConvertPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '394',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
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
      EventName.tapOnTheButtonConfirmOnConvertOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '395',
        PropertyType.assetFrom: convertFromAsset,
        PropertyType.assetTo: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
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
      EventName.successConvertEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '396',
        PropertyType.assetFrom: convertFromAsset,
        PropertyType.assetTo: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  void failedConvertEndScreenView({
    required String enteredAmount,
    required String convertFromAsset,
    required String convertToAsset,
    required String nowInput,
    required String errorText,
  }) {
    _analytics.logEvent(
      EventName.failedConvertEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '397',
        PropertyType.assetFrom: convertFromAsset,
        PropertyType.assetTo: convertToAsset,
        PropertyType.nowInput: nowInput,
        PropertyType.amount: enteredAmount,
        PropertyType.errorCode: errorText,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.convertFlow.id,
      },
    );
  }

  // Simple card
  void viewGetSimpleCard() {
    _analytics.logEvent(
      EventName.viewGetSimpleCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '429',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnGetSimpleCard({
    required String source,
  }) {
    _analytics.logEvent(
      EventName.tapOnGetSimpleCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '430',
        PropertyType.source: source,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewCardTypeSheet() {
    _analytics.logEvent(
      EventName.viewCardTypeSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '431',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnVirtualCard() {
    _analytics.logEvent(
      EventName.tapOnVirtualCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '432',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void confirmWithPinView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.confirmWithPinView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '433',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.viewSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '434',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapCloseSetUpPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapCloseSetUpPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '435',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapHideSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapHideSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '436',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapShowSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapShowSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '437',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapContinueSetupPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapContinueSetupPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '438',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewCompleteKYCForCard() {
    _analytics.logEvent(
      EventName.viewCompleteKYCForCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '439',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapVerifyAccountForCard() {
    _analytics.logEvent(
      EventName.tapVerifyAccountForCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '440',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapCancelKYCForCard() {
    _analytics.logEvent(
      EventName.tapCancelKYCForCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '441',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewPleaseWaitLoading() {
    _analytics.logEvent(
      EventName.viewPleaseWaitLoading,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '442',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewKYCSumsubCreation() {
    _analytics.logEvent(
      EventName.viewKYCSumsubCreation,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '443',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewWorkingOnYourCard() {
    _analytics.logEvent(
      EventName.viewWorkingOnYourCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '444',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewCardIsReady() {
    _analytics.logEvent(
      EventName.viewCardIsReady,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '445',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewEURWalletWithoutButton() {
    _analytics.logEvent(
      EventName.viewEURWalletWithoutButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '446',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewEURWalletWithButton() {
    _analytics.logEvent(
      EventName.viewEURWalletWithButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '447',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnSimpleCard() {
    _analytics.logEvent(
      EventName.tapOnSimpleCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '448',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewVirtualCardScreen({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.viewVirtualCardScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '449',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapShowCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapShowCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '450',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapHideCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapHideCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '451',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapCopyCardNumber({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapCopyCardNumber,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '452',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewErrorOnCardScreen({
    required String cardID,
    required String reason,
  }) {
    _analytics.logEvent(
      EventName.viewErrorOnCardScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '453',
        PropertyType.cardID: cardID,
        PropertyType.reason: reason,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapBackFromVirualCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapBackFromVirualCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '454',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapFreezeCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapFreezeCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '455',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewFreezeCardPopup({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.viewFreezeCardPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '456',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapConfirmFreezeCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapConfirmFreezeCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '457',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapCancelFreeze({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapCancelFreeze,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '458',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewFrozenCard({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.viewFrozenCard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '459',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnUnfreeze({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnUnfreeze,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '460',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  // Terminate Simple card
  void tapOnTheTerminateButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheTerminateButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '461',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void terminateWithBalancePopupScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.terminateWithBalancePopupScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '462',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void approveTerminatePopupScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.approveTerminatePopupScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '463',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnTheCancelTerminateButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheCancelTerminateButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '464',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnTheConfirmTerminateButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheConfirmTerminateButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '465',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void confirmTerminateWithPinScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.confirmTerminateWithPinScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '466',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void pleaseWaitLoaderOnCardTerminateLoadingView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.pleaseWaitLoaderOnCardTerminateLoadingView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '467',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void theCardHasBeenTerminateToastView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.theCardHasBeenTerminateToastView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '468',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnAddCash({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnAddCash,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '469',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewAddCashSheet({
    required String cardID,
    required String assets,
  }) {
    _analytics.logEvent(
      EventName.viewAddCashSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '470',
        PropertyType.cardID: cardID,
        PropertyType.availableAssetsList: assets,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnAddCashFromAsset({
    required String cardID,
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.tapOnAddCashFromAsset,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '471',
        PropertyType.cardID: cardID,
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewErrorOnSellScreen({
    required String cardID,
    required String reason,
  }) {
    _analytics.logEvent(
      EventName.viewErrorOnSellScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '472',
        PropertyType.cardID: cardID,
        PropertyType.reason: reason,
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnSettings({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnSettings,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '473',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewCardSettings({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.viewCardSettings,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '474',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnRemindPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnRemindPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '475',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewRemindPinSheet({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.viewRemindPinSheet,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '476',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnCancelRemindPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnCancelRemindPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '477',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapInContinueRemindPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapInContinueRemindPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '478',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnSetPassword({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnSetPassword,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '479',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void viewConfirmWithPin({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.viewConfirmWithPin,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '480',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  //Limits Simple Card
  void tapOnTheSpendingVirtualCardLimitsButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheSpendingVirtualCardLimitsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '481',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void spendingVirtualCardLimitsScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.spendingVirtualCardLimitsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '482',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnTheBackFromSpendingVirtualCardLimitsButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheBackFromSpendingVirtualCardLimitsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '483',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  // Edit Simple card lable
  void tapOnTheEditVirtualCardLabelButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheEditVirtualCardLabelButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '484',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void editVirtualCardLabelScreenView({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.editVirtualCardLabelScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '485',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnTheBackFromEditVirtualCardLabelButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheBackFromEditVirtualCardLabelButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '486',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnTheSaveChangesFromEditVirtualCardLabelButton({
    required String cardID,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheSaveChangesFromEditVirtualCardLabelButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '487',
        PropertyType.cardID: cardID,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void onboardingFinanceIsSimpleScreenView() {
    _analytics.logEvent(
      EventName.onboardingFinanceIsSimpleScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '489',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.onboarding.id,
      },
    );
  }

  // Transfer flow

  void tapOnTheDepositButton({
    required String source,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '498',
        PropertyType.source: source,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void errorDepositIsUnavailable() {
    _analytics.logEvent(
      EventName.errorDepositIsUnavailable,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '499',
        PropertyType.eventType: EventType.error.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void depositToScreenView() {
    _analytics.logEvent(
      EventName.depositToScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '500',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void depositByScreenView() {
    _analytics.logEvent(
      EventName.depositByScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '502',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnTheAnyAccountForDepositButton({
    required String accountType,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheAnyAccountForDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '503',
        PropertyType.account: accountType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void addCashFromTrScreenView() {
    _analytics.logEvent(
      EventName.addCashFromTrScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '504',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnTheAnyCryptoForDepositButton({
    required String cryptoAsset,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheAnyCryptoForDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '505',
        PropertyType.asset: cryptoAsset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void transferAmountScreenView({
    required String sourceTransfer,
  }) {
    _analytics.logEvent(
      EventName.transferAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '506',
        PropertyType.sourceTransfer: sourceTransfer,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnTheTransferFromButton({
    required String currentFromValueForTransfer,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheTransferFromButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '507',
        PropertyType.transferFrom: currentFromValueForTransfer,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void transferFromSheetView() {
    _analytics.logEvent(
      EventName.transferFromSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '508',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnSelectedNewTransferFromAccountButton({
    required String newTransferFromAccount,
  }) {
    _analytics.logEvent(
      EventName.tapOnSelectedNewTransferFromAccountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '509',
        PropertyType.transferFrom: newTransferFromAccount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnTheTransferToButton({
    required String currentToValueForTransfer,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheTransferToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '510',
        PropertyType.transferTo: currentToValueForTransfer,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void transferToSheetView() {
    _analytics.logEvent(
      EventName.transferToSheetView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '511',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnSelectedNewTransferToButton({
    required String newTransferToAccount,
  }) {
    _analytics.logEvent(
      EventName.tapOnSelectedNewTransferToButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '512',
        PropertyType.transferTo: newTransferToAccount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnTheContinueWithTransferAmountButton({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheContinueWithTransferAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '514',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void transferOrderSummaryScreenView({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.transferOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '515',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapAnTheButtonConfirmOnTransferOrderSummary({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.tapAnTheButtonConfirmOnTransferOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '517',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void successTransferEndScreenView({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.successTransferEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '518',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void failedTransferEndScreenView({
    required String transferFrom,
    required String transferTo,
    required String enteredAmount,
  }) {
    _analytics.logEvent(
      EventName.failedTransferEndScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '519',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: enteredAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  //

  void pushNotificationSV() {
    _analytics.logEvent(
      EventName.pushNotificationSV,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '493',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.pushPermission.id,
      },
    );
  }

  void pushNotificationButtonTap() {
    _analytics.logEvent(
      EventName.pushNotificationButtonTap,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '494',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.pushPermission.id,
      },
    );
  }

  void pushNotificationAlertView() {
    _analytics.logEvent(
      EventName.pushNotificationAlertView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '495',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.pushPermission.id,
      },
    );
  }

  void pushNotificationAgree() {
    _analytics.logEvent(
      EventName.pushNotificationAgree,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '496',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.pushPermission.id,
      },
    );
  }

  void pushNotificationDisagree() {
    _analytics.logEvent(
      EventName.pushNotificationDisagree,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '497',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.pushPermission.id,
      },
    );
  }

  void tapOnTheTabbarButtonEarn() {
    _analytics.logEvent(
      EventName.tapOnTheTabbarButtonEarn,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '520',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnMainScreenView() {
    _analytics.logEvent(
      EventName.earnMainScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '521',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void allOffersScreenView() {
    _analytics.logEvent(
      EventName.allOffersScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '523',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheAnyOfferButton({
    required String assetName,
    required String sourse,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheAnyOfferButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '524',
        PropertyType.assetName: assetName,
        PropertyType.source: sourse,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void chooseEarnPlanScreenView({required String assetName}) {
    _analytics.logEvent(
      EventName.chooseEarnPlanScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '525',
        PropertyType.assetName: assetName,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheContinueWithEarnPlanButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';
    _analytics.logEvent(
      EventName.tapOnTheContinueWithEarnPlanButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '526',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnDepositAmountScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.earnDepositAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '527',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnDepositCryptoWalletPopupView({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.earnDepositCryptoWalletPopupView,
      eventProperties: {
        PropertyType.assetName: assetName,
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '528',
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheTopUpEarnWalletButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.tapOnTheTopUpEarnWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '529',
        PropertyType.assetName: assetName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheCancelTopUpEarnWalletButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.tapOnTheCancelTopUpEarnWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '530',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheContinueEarnAmountDepositButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.tapOnTheContinueEarnAmountDepositButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '531',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnDepositOrderSummaryScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.earnDepositOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '532',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheConfirmEarnDepositOrderSummaryButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.tapOnTheConfirmEarnDepositOrderSummaryButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '533',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void successEarnDepositScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.successEarnDepositScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '534',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void failedEarnDepositScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.failedEarnDepositScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '535',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheAnyActiveEarnButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
    required String earnOfferStatus,
    required String revenue,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate)}%';

    _analytics.logEvent(
      EventName.tapOnTheAnyActiveEarnButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '536',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.earnOfferStatus: earnOfferStatus,
        PropertyType.revenue: revenue,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void activeCryptoSavingsScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
    required String earnOfferStatus,
    required String earnOfferId,
    required String revenue,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.activeCryptoSavingsScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '537',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.earnOfferStatus: earnOfferStatus,
        PropertyType.revenue: revenue,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheHistoryFromActiveCryptoSavingsButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
    required String earnOfferStatus,
    required String revenue,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.tapOnTheHistoryFromActiveCryptoSavingsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '539',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.earnOfferStatus: earnOfferStatus,
        PropertyType.revenue: revenue,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheTopUpFromActiveCryptoSavingsButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
    required String earnOfferStatus,
    required String revenue,
    required String earnOfferId,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.tapOnTheTopUpFromActiveCryptoSavingsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '540',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.earnOfferStatus: earnOfferStatus,
        PropertyType.revenue: revenue,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheWithdrawFromActiveCryptoSavingsButton({
    required String assetName,
    required String earnPlanName,
    required String earnAPYrate,
    required String earnWithdrawalType,
    required String earnDepositAmount,
    required String earnOfferStatus,
    required String revenue,
    required String earnOfferId,
  }) {
    final finalEarnAPYrate = '${double.parse(earnAPYrate) * 100}%';

    _analytics.logEvent(
      EventName.tapOnTheWithdrawFromActiveCryptoSavingsButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '541',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnAPYrate: finalEarnAPYrate,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.earnDepositAmount: earnDepositAmount,
        PropertyType.earnOfferStatus: earnOfferStatus,
        PropertyType.revenue: revenue,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnWithdrawTypeScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
  }) {
    _analytics.logEvent(
      EventName.earnWithdrawTypeScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '542',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void sureFullEarnWithdrawPopupView({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
  }) {
    _analytics.logEvent(
      EventName.sureFullEarnWithdrawPopupView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '543',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheContinueEarningButton({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheContinueEarningButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '544',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheYesWithdrawButton({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheYesWithdrawButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '545',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheContinueWithEarnWithdrawTypeButton({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required bool fullWithdrawType,
    required String earnOfferId,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheContinueWithEarnWithdrawTypeButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '546',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.fullWithdrawType: fullWithdrawType,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnWithdrawAmountScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
    required bool fullWithdrawType,
  }) {
    _analytics.logEvent(
      EventName.earnWithdrawAmountScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '547',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.fullWithdrawType: fullWithdrawType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheContinueWithEarnWithdrawAmountButton({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
    required String withdrawAmount,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheContinueWithEarnWithdrawAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '549',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.withdrawAmount: withdrawAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnWithdrawOrderSummaryScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
    required String withdrawAmount,
  }) {
    _analytics.logEvent(
      EventName.earnWithdrawOrderSummaryScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '550',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.withdrawAmount: withdrawAmount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheBackFromEarnWithdrawOrderSummaryButton({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
    required String withdrawAmount,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheBackFromEarnWithdrawOrderSummaryButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '551',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.withdrawAmount: withdrawAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheConfirmWithdrawOrderSummaryButton({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
    required String withdrawAmount,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheContinueWithEarnWithdrawAmountButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '552',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.withdrawAmount: withdrawAmount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void successEarnWithdrawScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
    required String withdrawAnount,
  }) {
    _analytics.logEvent(
      EventName.successEarnWithdrawScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '553',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.withdrawAmount: withdrawAnount,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void failedEarnMainScreenView({
    required String assetName,
    required String earnPlanName,
    required String earnWithdrawalType,
    required String earnOfferId,
    required String withdrawAnount,
  }) {
    _analytics.logEvent(
      EventName.failedEarnMainScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '554',
        PropertyType.assetName: assetName,
        PropertyType.earnPlanName: earnPlanName,
        PropertyType.earnOfferId: earnOfferId,
        PropertyType.winAmount: withdrawAnount,
        PropertyType.earnWithdrawalType: earnWithdrawalType,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheHistoryEarnbutton() {
    _analytics.logEvent(
      EventName.tapOnTheHistoryEarnbutton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '555',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void earnsArchiveScreenView() {
    _analytics.logEvent(
      EventName.earnsArchiveScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '556',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.earn.id,
      },
    );
  }

  void tapOnTheAddToGoogleWalletButton({required String cardId}) {
    _analytics.logEvent(
      EventName.tapOnTheAddToGoogleWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '557',
        PropertyType.cardID: cardId,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnTheAddToAppleWalletButton({required String cardId}) {
    _analytics.logEvent(
      EventName.tapOnTheAddToAppleWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '558',
        PropertyType.cardID: cardId,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void popupAddCardToWalletScreenView({required String cardId}) {
    _analytics.logEvent(
      EventName.popupAddCardToWalletScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '559',
        PropertyType.cardID: cardId,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  void tapOnTheContinueAddToWalletButton({required String cardId}) {
    _analytics.logEvent(
      EventName.tapOnTheContinueAddToWalletButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '560',
        PropertyType.cardID: cardId,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.cardFlow.id,
      },
    );
  }

  // Confirm Transfer via SMS

  void confirmTransferViaSMSScreenView({
    required String transferFrom,
    required String transferTo,
    required String amount,
  }) {
    _analytics.logEvent(
      EventName.confirmTransferViaSMSScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '561',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: amount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnTheButtonContinueOnConfirmViaSMSScreen({
    required String transferFrom,
    required String transferTo,
    required String amount,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonContinueOnConfirmViaSMSScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '562',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: amount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void tapOnTheButtonCancelOnConfirmViaSMSScreen({
    required String transferFrom,
    required String transferTo,
    required String amount,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheButtonCancelOnConfirmViaSMSScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '563',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: amount,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  void confirmCodeTransferViaSMSScreenView({
    required String transferFrom,
    required String transferTo,
    required String amount,
  }) {
    _analytics.logEvent(
      EventName.confirmCodeTransferViaSMSScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '564',
        PropertyType.transferFrom: transferFrom,
        PropertyType.transferTo: transferTo,
        PropertyType.amount: amount,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.transferFlow.id,
      },
    );
  }

  // Market
  void tapOnTheTabbarButtonMarket() {
    _analytics.logEvent(
      EventName.tapOnTheTabbarButtonMarket,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '607',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.market.id,
      },
    );
  }

  void marketListScreenView() {
    _analytics.logEvent(
      EventName.marketListScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '608',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.market.id,
      },
    );
  }

  void tapOnTheAnyAssetOnMarketList({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheAnyAssetOnMarketList,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '609',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.market.id,
      },
    );
  }

  void marketAssetScreenView({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.marketAssetScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '610',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.market.id,
      },
    );
  }

  void tapOnTheBackButtonFromMarketAssetScreen({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheBackButtonFromMarketAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '611',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.market.id,
      },
    );
  }

  void tapOnTheBalanceButtonOnMarketAssetScreen({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheBalanceButtonOnMarketAssetScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '612',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.market.id,
      },
    );
  }

  void tapOnTheBanner({
    required String bannerId,
    required String bannerTitle,
  }) {
    _analytics.logEvent(
      EventName.tapOnTheBanner,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '613',
        PropertyType.bannerId: bannerId,
        PropertyType.bannerTitle: bannerTitle,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.banners.id,
      },
    );
  }

  void closeBanner({
    required String bannerId,
    required String bannerTitle,
  }) {
    _analytics.logEvent(
      EventName.closeBanner,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '614',
        PropertyType.bannerId: bannerId,
        PropertyType.bannerTitle: bannerTitle,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.banners.id,
      },
    );
  }

  void tapOnTheSellButtonOnWalletsScr() {
    _analytics.logEvent(
      EventName.tapOnTheSellButtonOnWalletsScr,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '615',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.sellFlow.id,
      },
    );
  }

  // Simple Coin
  void simplecoinLandingScreenView() {
    _analytics.logEvent(
      EventName.simplecoinLandingScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '627',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void tapOnTheButtonBackOnSimplecoinLandingScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonBackOnSimplecoinLandingScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '628',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void tapOnTheButtonTrxHistoryOnSimplecoinLandingScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonTrxHistoryOnSimplecoinLandingScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '629',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void tapOnTheButtonJoinSimpleTapOnSimplecoinLandingScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonJoinSimpleTapOnSimplecoinLandingScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '630',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void collectSimplecoinPopupScreenView() {
    _analytics.logEvent(
      EventName.collectSimplecoinPopupScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '631',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void tapOnTheButtonCollectOnCollectSimplecoinPopup() {
    _analytics.logEvent(
      EventName.tapOnTheButtonCollectOnCollectSimplecoinPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '632',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void tapOnTheButtonDeclineOnCollectSimplecoinPopup() {
    _analytics.logEvent(
      EventName.tapOnTheButtonDeclineOnCollectSimplecoinPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '633',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void tapOnTheButtonDisclamerOnCollectSimplecoinPopup() {
    _analytics.logEvent(
      EventName.tapOnTheButtonDisclamerOnCollectSimplecoinPopup,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '634',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  void tapOnTheButtonSimplecoinOnWalletScreen() {
    _analytics.logEvent(
      EventName.tapOnTheButtonSimplecoinOnWalletScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '635',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.withdrawSimpleCoin.id,
      },
    );
  }

  // P2P buy
  void ptpBuyPaymentCurrencyScreenView({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.ptpBuyPaymentCurrencyScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '616',
        PropertyType.pmType: 'PTP',
        PropertyType.buyPM: 'PTP',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void tapOnThePTPBuyCurrencyButton({
    required String asset,
    required String ptpCurrency,
  }) {
    _analytics.logEvent(
      EventName.tapOnThePTPBuyCurrencyButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '618',
        PropertyType.pmType: 'PTP',
        PropertyType.buyPM: 'PTP',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
        PropertyType.ptpCurrency: ptpCurrency,
      },
    );
  }

  void ptpBuyPaymentMethodScreenView({
    required String asset,
    required String ptpCurrency,
  }) {
    _analytics.logEvent(
      EventName.ptpBuyPaymentMethodScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '619',
        PropertyType.pmType: 'PTP',
        PropertyType.buyPM: 'PTP',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
        PropertyType.ptpCurrency: ptpCurrency,
      },
    );
  }

  void tapOnThePTPBuyMethodButton({
    required String asset,
    required String ptpCurrency,
    required String ptpBuyMethod,
  }) {
    _analytics.logEvent(
      EventName.tapOnThePTPBuyMethodButton,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '621',
        PropertyType.pmType: 'PTP',
        PropertyType.buyPM: 'PTP',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
        PropertyType.ptpCurrency: ptpCurrency,
        PropertyType.ptpBuyMethod: ptpBuyMethod,
      },
    );
  }

  void ptpBuyWebViewScreenView({
    required String asset,
    required String ptpCurrency,
    required String ptpBuyMethod,
  }) {
    _analytics.logEvent(
      EventName.ptpBuyWebViewScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '622',
        PropertyType.pmType: 'PTP',
        PropertyType.buyPM: 'PTP',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
        PropertyType.ptpCurrency: ptpCurrency,
        PropertyType.ptpBuyMethod: ptpBuyMethod,
      },
    );
  }

  void ptpBuyPopupUnfinishedOperationScreenView({
    required String asset,
  }) {
    _analytics.logEvent(
      EventName.ptpBuyPopupUnfinishedOperationScreenView,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '623',
        PropertyType.pmType: 'PTP',
        PropertyType.buyPM: 'PTP',
        PropertyType.asset: asset,
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.buyFlow.id,
      },
    );
  }

  void jarTapOnButtonAddCryptoJarOnDashboard() {
    _analytics.logEvent(
      EventName.jarTapOnButtonAddCryptoJarOnDashboard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '636',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarScreenViewJarName() {
    _analytics.logEvent(
      EventName.jarScreenViewJarName,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '637',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonNextOnJarName() {
    _analytics.logEvent(
      EventName.jarTapOnButtonNextOnJarName,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '638',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarScreenViewJarGoal() {
    _analytics.logEvent(
      EventName.jarScreenViewJarGoal,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '639',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonNextOnJarGoal({
    required String asset,
    required String network,
    required int target,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonNextOnJarGoal,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '640',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
      },
    );
  }

  void jarScreenViewCreatingJar() {
    _analytics.logEvent(
      EventName.jarScreenViewCreatingJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '641',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonCreateOnCreatingJar({
    required String asset,
    required String network,
    required int target,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonCreateOnCreatingJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '642',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
      },
    );
  }

  void jarScreenViewJar({
    required String jarName,
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarScreenViewJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '643',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.jarName: jarName,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonMoreOnJar() {
    _analytics.logEvent(
      EventName.jarTapOnButtonMoreOnJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '644',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonChangeJarNameOnJarAction() {
    _analytics.logEvent(
      EventName.jarTapOnButtonChangeJarNameOnJarAction,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '645',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonChangeGoalOnJarAction() {
    _analytics.logEvent(
      EventName.jarTapOnButtonChangeGoalOnJarAction,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '646',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonChangeDescriptionOnJarAction() {
    _analytics.logEvent(
      EventName.jarTapOnButtonChangeDescriptionOnJarAction,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '647',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarScreenViewJarDescription() {
    _analytics.logEvent(
      EventName.jarScreenViewJarDescription,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '648',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonNextOnJarDescription() {
    _analytics.logEvent(
      EventName.jarTapOnButtonNextOnJarDescription,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '649',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonShareOnJar() {
    _analytics.logEvent(
      EventName.jarTapOnButtonShareOnJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '650',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarScreenViewShareJar() {
    _analytics.logEvent(
      EventName.jarScreenViewShareJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '651',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonShareJarOnShareJar({required String language}) {
    _analytics.logEvent(
      EventName.jarTapOnButtonShareJarOnShareJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '652',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.language: language,
      },
    );
  }

  void jarTapOnButtonWithdrawOnJar({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonWithdrawOnJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '653',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarScreenViewWithdrawJar({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarScreenViewWithdrawJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '654',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonContinueJarWithdrawOnWithdraw({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonContinueJarWithdrawOnWithdraw,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '655',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarScreenViewOrderSummaryWithdrawJar({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarScreenViewOrderSummaryWithdrawJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '656',
        PropertyType.eventType: EventType.screenView.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonConfirmJarWithdrawOnOrderSummary({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonConfirmJarWithdrawOnOrderSummary,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '657',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonCloseOnJar({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonCloseOnJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '658',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonConfirmCloseOnJarClosePopUp({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonConfirmCloseOnJarClosePopUp,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '659',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonCancelCloseOnJarClosePopUp({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonCancelCloseOnJarClosePopUp,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '660',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonViewAllTrxOnJarScreen() {
    _analytics.logEvent(
      EventName.jarTapOnButtonViewAllTrxOnJarScreen,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '661',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonJarItemOnDashboard({
    required String jarName,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonJarItemOnDashboard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '662',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.jarName: jarName,
      },
    );
  }

  void jarTapOnButtonAllJarsItemOnDashboard() {
    _analytics.logEvent(
      EventName.jarTapOnButtonAllJarsItemOnDashboard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '663',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarTapOnButtonActiveJarsItemsOnDashboard() {
    _analytics.logEvent(
      EventName.jarTapOnButtonActiveJarsItemsOnDashboard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '664',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }

  void jarScreenViewCloseBalanceErrorDialogOnJar({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarScreenViewCloseBalanceErrorDialogOnJar,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '665',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonYesOnCloseBalanceErrorDialog({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonYesOnCloseBalanceErrorDialog,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '666',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonNoOnCloseBalanceErrorDialog({
    required String asset,
    required String network,
    required int target,
    required double balance,
    required bool isOpen,
  }) {
    _analytics.logEvent(
      EventName.jarTapOnButtonNoOnCloseBalanceErrorDialog,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '667',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
        PropertyType.asset: asset,
        PropertyType.network: network,
        PropertyType.target: target,
        PropertyType.balance: balance.toStringAsFixed(2),
        PropertyType.isOpen: isOpen,
      },
    );
  }

  void jarTapOnButtonViewAllJarsOnDashboard() {
    _analytics.logEvent(
      EventName.jarTapOnButtonViewAllJarsOnDashboard,
      eventProperties: {
        PropertyType.techAcc: isTechAcc,
        PropertyType.kycStatus: kycDepositStatus,
        PropertyType.eventId: '668',
        PropertyType.eventType: EventType.tap.name,
        PropertyType.eventCategory: EventCategory.jar.id,
      },
    );
  }
}
