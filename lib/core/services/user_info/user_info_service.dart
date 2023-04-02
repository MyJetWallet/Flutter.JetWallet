import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/helpers/biometrics_auth_helpers.dart';

final sUserInfo = getIt.get<UserInfoService>();

class UserInfoService {
  static final _logger = Logger('UserInfoNotifier');

  final storage = getIt.get<LocalStorageService>();

  String? pin;

  final _hasDisclaimers = Observable(false);
  bool get hasDisclaimers => _hasDisclaimers.value;
  set hasDisclaimers(bool newValue) => _hasDisclaimers.value = newValue;

  final _hasNftDisclaimers = Observable(false);
  bool get hasNftDisclaimers => _hasNftDisclaimers.value;
  set hasNftDisclaimers(bool newValue) => _hasNftDisclaimers.value = newValue;

  final _hasHighYieldDisclaimers = Observable(false);
  bool get hasHighYieldDisclaimers => _hasHighYieldDisclaimers.value;
  set hasHighYieldDisclaimers(bool newValue) =>
      _hasHighYieldDisclaimers.value = newValue;

  /// If after reister/login user disabled a pin.
  /// If pin is disabled manually we don't ask
  /// to set pin again (in authorized state)
  /// After logout this will be reseted
  final _pinDisabled = Observable(false);
  bool get pinDisabled => _pinDisabled.value;
  set pinDisabled(bool newValue) => _pinDisabled.value = newValue;

  final _twoFaEnabled = Observable(false);
  bool get twoFaEnabled => _twoFaEnabled.value;
  set twoFaEnabled(bool newValue) => _twoFaEnabled.value = newValue;

  final _phoneVerified = Observable(false);
  bool get phoneVerified => _phoneVerified.value;
  set phoneVerified(bool newValue) => _phoneVerified.value = newValue;

  final _emailConfirmed = Observable(false);
  bool get emailConfirmed => _emailConfirmed.value;
  set emailConfirmed(bool newValue) => _emailConfirmed.value = newValue;

  final _phoneConfirmed = Observable(false);
  bool get phoneConfirmed => _phoneConfirmed.value;
  set phoneConfirmed(bool newValue) =>
      _hasHighYieldDisclaimers.value = newValue;

  final _kycPassed = Observable(false);
  bool get kycPassed => _kycPassed.value;
  set kycPassed(bool newValue) => _kycPassed.value = newValue;

  ///

  final _isJustLogged = Observable(false);
  bool get isJustLogged => _isJustLogged.value;
  set isJustLogged(bool newValue) => _isJustLogged.value = newValue;

  final _isJustRegistered = Observable(false);
  bool get isJustRegistered => _isJustRegistered.value;
  set isJustRegistered(bool newValue) => _isJustRegistered.value = newValue;

  final _biometricDisabled = Observable(false);
  bool get biometricDisabled => _biometricDisabled.value;
  set biometricDisabled(bool newValue) => _biometricDisabled.value = newValue;

  final _isTechClient = Observable(false);
  bool get isTechClient => _isTechClient.value;
  set isTechClient(bool newValue) => _isTechClient.value = newValue;

  ///

  final _isSignalRInited = Observable(false);
  bool get isSignalRInited => _isSignalRInited.value;
  set isSignalRInited(bool newValue) => _isSignalRInited.value = newValue;

  final _isServicesRegisterd = Observable(false);
  bool get isServicesRegisterd => _isServicesRegisterd.value;
  set isServicesRegisterd(bool newValue) =>
      _isServicesRegisterd.value = newValue;

  ///

  final _email = Observable('');
  String get email => _email.value;
  set email(String newValue) => _email.value = newValue;

  final _phone = Observable('');
  String get phone => _phone.value;
  set phone(String newValue) => _phone.value = newValue;

  final _referralLink = Observable('');
  String get referralLink => _referralLink.value;
  set referralLink(String newValue) => _referralLink.value = newValue;

  final _referralCode = Observable('');
  String get referralCode => _referralCode.value;
  set referralCode(String newValue) => _referralCode.value = newValue;

  final _countryOfRegistration = Observable('');
  String get countryOfRegistration => _countryOfRegistration.value;
  set countryOfRegistration(String newValue) =>
      _countryOfRegistration.value = newValue;

  final _countryOfResidence = Observable('');
  String get countryOfResidence => _countryOfResidence.value;
  set countryOfResidence(String newValue) =>
      _countryOfResidence.value = newValue;

  final _countryOfCitizenship = Observable('');
  String get countryOfCitizenship => _countryOfCitizenship.value;
  set countryOfCitizenship(String newValue) =>
      _countryOfCitizenship.value = newValue;

  final _firstName = Observable('');
  String get firstName => _firstName.value;
  set firstName(String newValue) => _firstName.value = newValue;

  final _lastName = Observable('');
  String get lastName => _lastName.value;
  set lastName(String newValue) => _lastName.value = newValue;

  bool get pinEnabled => pin != null;

  bool get isPhoneNumberSet => phone.isNotEmpty;

  bool get isShowBanner => !twoFaEnabled || !phoneVerified || !kycPassed;

  void updateSignalRStatus(bool value) => isSignalRInited = value;
  void updateServicesRegistred(bool value) => isServicesRegisterd = value;

  void updateWithValuesFromSessionInfo({
    required bool twoFaEnabledValue,
    required bool phoneVerifiedValue,
    required bool hasDisclaimersValue,
    required bool hasHighYieldDisclaimersValue,
    required bool hasNftDisclaimersValue,
    required bool isTechClientValue,
  }) {
    twoFaEnabled = twoFaEnabledValue;
    phoneVerified = phoneVerifiedValue;
    hasDisclaimers = hasDisclaimersValue;
    hasHighYieldDisclaimers = hasHighYieldDisclaimersValue;
    hasNftDisclaimers = hasNftDisclaimersValue;
    isTechClient = isTechClientValue;
  }

  // ignore: long-parameter-list
  void updateWithValuesFromProfileInfo({
    required bool emailConfirmedValue,
    required bool phoneConfirmedValue,
    required bool kycPassedValue,
    required String emailValue,
    required String phoneValue,
    required String referralLinkValue,
    required String referralCodeValue,
    required String countryOfRegistrationValue,
    required String countryOfResidenceValue,
    required String countryOfCitizenshipValue,
    required String firstNameValue,
    required String lastNameValue,
  }) {
    _logger.log(notifier, 'updateWithValuesFromProfileInfo');

    emailConfirmed = emailConfirmedValue;
    phoneConfirmed = phoneConfirmedValue;
    kycPassed = kycPassedValue;
    email = emailValue;
    phone = phoneValue;
    referralLink = referralLinkValue;
    referralCode = referralCodeValue;
    countryOfRegistration = countryOfRegistrationValue;
    countryOfResidence = countryOfResidenceValue;
    countryOfCitizenship = countryOfCitizenshipValue;
    firstName = firstNameValue;
    lastName = lastNameValue;
  }

  /// Inits PIN/Biometrics information
  Future<void> initPinStatus() async {
    _logger.log(notifier, 'initPinStatus');
    final pin = await storage.getValue(pinStatusKey);

    if (pin == null || pin.isEmpty) {
      _updatePin(null);
    } else {
      _updatePin(pin);
    }

    final pinDisabled = await storage.getValue(pinDisabledKey);

    if (pinDisabled == null) {
      _updatePinDisabled(false);
    } else {
      _updatePinDisabled(true);
    }
  }

  Future<void> disablePin() async {
    _logger.log(notifier, 'disablePin');

    await storage.setString(pinDisabledKey, 'disabled');
    _updatePinDisabled(true);
  }

  /// Set PIN/Biometrics information
  Future<void> setPin(String value) async {
    _logger.log(notifier, 'setPin');

    await storage.setString(pinStatusKey, value);
    _updatePin(value);
  }

  /// Reset PIN/Biometrics information
  Future<void> resetPin() async {
    _logger.log(notifier, 'resetPin');

    await storage.setString(pinStatusKey, '');
    _updatePin(null);
  }

  void _updatePin(String? value) {
    pin = value;
  }

  void _updatePinDisabled(bool value) {
    pinDisabled = value;
  }

  Future<void> initBiometricStatus() async {
    _logger.log(notifier, 'initBiometricStatus');
    final bioStatusFromSetting = await biometricStatus();

    if (bioStatusFromSetting == BiometricStatus.none) {
      _updateBiometric(true);
    } else {
      final bioStatus = await storage.getValue(useBioKey);
      final hideBio = bioStatus != 'true';
      _updateBiometric(hideBio);
    }
  }

  void updateIsJustLogged({required bool value}) {
    isJustLogged = value;
  }

  void updateIsJustRegistered({required bool value}) {
    isJustRegistered = value;
  }

  void _updateBiometric(bool hideBio) {
    biometricDisabled = hideBio;
  }

  Future<void> disableBiometric() async {
    biometricDisabled = true;

    await storage.setString(useBioKey, false.toString());
  }

  void updateTwoFaStatus({required bool enabled}) {
    _logger.log(notifier, 'updateTwoFaStatus');

    twoFaEnabled = enabled;
  }

  void updatePhoneVerified({required bool phoneVerifiedValue}) {
    _logger.log(notifier, 'updatePhoneVerified');

    phoneVerified = phoneVerifiedValue;
  }

  void updateEmail(String value) {
    _logger.log(notifier, 'updateEmail');

    email = value;
  }

  void updatePhone(String value) {
    _logger.log(notifier, 'updatePhone');

    phone = value;
  }

  void clear() {
    pin = null;
    phoneVerified = false;
    twoFaEnabled = false;
    emailConfirmed = false;
    phoneConfirmed = false;
    kycPassed = false;
    email = '';
    phone = '';
    countryOfRegistration = '';
    countryOfResidence = '';
    countryOfCitizenship = '';
    referralLink = '';
    referralCode = '';
    firstName = '';
    lastName = '';
  }
}
