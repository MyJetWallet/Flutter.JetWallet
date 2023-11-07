import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/helpers/biometrics_auth_helpers.dart';

part 'user_info_service.g.dart';

final sUserInfo = getIt.get<UserInfoService>();

class UserInfoService = _UserInfoServiceBase with _$UserInfoService;

abstract class _UserInfoServiceBase with Store {
  static final _logger = Logger('UserInfoNotifier');

  final storage = getIt.get<LocalStorageService>();

  String? pin;

  @observable
  bool isSignalRInited = false;

  @observable
  bool isServicesRegisterd = false;

  @observable
  bool chatClosedOnThisSession = false;

  @observable
  bool hasDisclaimers = false;

  @observable
  bool hasNftDisclaimers = false;

  @observable
  bool pinDisabled = false;

  @observable
  bool twoFaEnabled = false;

  @observable
  bool phoneVerified = false;

  @observable
  bool emailConfirmed = false;

  @observable
  bool phoneConfirmed = false;

  @observable
  bool kycPassed = false;

  @observable
  bool hasHighYieldDisclaimers = false;

  @observable
  bool isJustLogged = false;

  @observable
  bool isJustRegistered = false;

  @observable
  bool biometricDisabled = true;

  @observable
  bool isTechClient = false;

  @observable
  bool cardAvailable = false;

  @observable
  bool cardRequested = false;

  @observable
  bool isSimpleCardAvailable = true;

  @observable
  bool isSimpleCardInProgress = false;

  @observable
  String email = '';

  @observable
  String phone = '';

  @observable
  String referralLink = '';

  @observable
  String referralCode = '';

  @observable
  String countryOfRegistration = '';

  @observable
  String countryOfResidence = '';

  @observable
  String countryOfCitizenship = '';

  @observable
  String firstName = '';

  @observable
  String lastName = '';

  @computed
  bool get pinEnabled => pin != null;

  @computed
  bool get isPhoneNumberSet => phone.isNotEmpty;

  @computed
  bool get isShowBanner => !twoFaEnabled || !phoneVerified || !kycPassed;

  @action
  void updateSignalRStatus(bool value) => isSignalRInited = value;

  @action
  void updateServicesRegistred(bool value) => isServicesRegisterd = value;

  @action
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
  @action
  void updateWithValuesFromProfileInfo({
    required bool emailConfirmedValue,
    required bool phoneConfirmedValue,
    required bool kycPassedValue,
    required bool cardAvailableValue,
    required bool cardRequestedValue,
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
    cardAvailable = cardAvailableValue;
    cardRequested = cardRequestedValue;
  }

  @action
  void updateCardRequested({required bool newValue}) {
    cardRequested = newValue;
  }

  /// Inits PIN/Biometrics information
  @action
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

    await initBiometricStatus();
  }

  @action
  Future<void> disablePin() async {
    _logger.log(notifier, 'disablePin');

    await storage.setString(pinDisabledKey, 'disabled');
    _updatePinDisabled(true);
  }

  /// Set PIN/Biometrics information
  @action
  Future<void> setPin(String value) async {
    _logger.log(notifier, 'setPin');

    await storage.setString(pinStatusKey, value);
    _updatePin(value);
  }

  /// Reset PIN/Biometrics information
  @action
  Future<void> resetPin() async {
    _logger.log(notifier, 'resetPin');

    await storage.setString(pinStatusKey, '');
    _updatePin(null);
  }

  @action
  void _updatePin(String? value) {
    pin = value;
  }

  @action
  void _updatePinDisabled(bool value) {
    pinDisabled = value;
  }

  @action
  Future<void> initBiometricStatus() async {
    _logger.log(notifier, 'initBiometricStatus');
    final bioStatusFromSetting = await biometricStatus();

    final isBiometricHided =
        await getIt<LocalCacheService>().getBiometricHided() ?? false;

    if (bioStatusFromSetting != BiometricStatus.none &&
        !isBiometricHided &&
        // this is in order not to show biometrics before the user is authorized
        pin != null) {
      updateBiometric(hideBiometric: false);
    } else {
      updateBiometric(hideBiometric: true);
    }
  }

  @action
  void updateIsJustLogged({required bool value}) {
    isJustLogged = value;
  }

  @action
  void updateIsJustRegistered({required bool value}) {
    isJustRegistered = value;
  }

  @action
  void updateBiometric({required bool hideBiometric}) {
    biometricDisabled = hideBiometric;
    getIt<LocalCacheService>().saveBiometricHided(hideBiometric);
  }

  @action
  void updateTwoFaStatus({required bool enabled}) {
    _logger.log(notifier, 'updateTwoFaStatus');

    twoFaEnabled = enabled;
  }

  @action
  void updatePhoneVerified({required bool phoneVerifiedValue}) {
    _logger.log(notifier, 'updatePhoneVerified');

    phoneVerified = phoneVerifiedValue;
  }

  @action
  void updateEmail(String value) {
    _logger.log(notifier, 'updateEmail');

    email = value;
  }

  @action
  void updatePhone(String value) {
    _logger.log(notifier, 'updatePhone');

    phone = value;
  }

  @action
  void clear() {
    pin = null;
    phoneVerified = false;
    twoFaEnabled = false;
    emailConfirmed = false;
    phoneConfirmed = false;
    kycPassed = false;
    isSignalRInited = false;
    biometricDisabled = true;
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
