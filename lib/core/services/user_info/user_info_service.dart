import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/helpers/biometrics_auth_helpers.dart';
import 'package:simple_networking/modules/wallet_api/models/card_add/card_check_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_request_model.dart';

import '../simple_networking/simple_networking.dart';
import 'models/user_info.dart';

final sUserInfo = getIt.get<UserInfoService>();

@lazySingleton
class UserInfoService {
  static final _logger = Logger('UserInfoNotifier');

  final storage = getIt.get<LocalStorageService>();

  UserInfoState userInfo = const UserInfoState();

  void updateWithValuesFromSessionInfo({
    required bool twoFaEnabled,
    required bool phoneVerified,
    required bool hasDisclaimers,
    required bool hasHighYieldDisclaimers,
    required bool hasNftDisclaimers,
    required bool isTechClient,
  }) {
    _logger.log(notifier, 'updateWithValuesFromSessionInfo');

    userInfo = userInfo.copyWith(
      twoFaEnabled: twoFaEnabled,
      phoneVerified: phoneVerified,
      hasDisclaimers: hasDisclaimers,
      hasHighYieldDisclaimers: hasHighYieldDisclaimers,
      hasNftDisclaimers: hasNftDisclaimers,
      isTechClient: isTechClient,
    );
  }

  // ignore: long-parameter-list
  void updateWithValuesFromProfileInfo({
    required bool emailConfirmed,
    required bool phoneConfirmed,
    required bool kycPassed,
    required String email,
    required String phone,
    required String referralLink,
    required String referralCode,
    required String countryOfRegistration,
    required String countryOfResidence,
    required String countryOfCitizenship,
    required String firstName,
    required String lastName,
  }) {
    _logger.log(notifier, 'updateWithValuesFromProfileInfo');

    userInfo = userInfo.copyWith(
      emailConfirmed: emailConfirmed,
      phoneConfirmed: phoneConfirmed,
      kycPassed: kycPassed,
      email: email,
      phone: phone,
      referralLink: referralLink,
      referralCode: referralCode,
      countryOfRegistration: countryOfRegistration,
      countryOfResidence: countryOfResidence,
      countryOfCitizenship: countryOfCitizenship,
      firstName: firstName,
      lastName: lastName,
    );
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
    userInfo = userInfo.copyWith(pin: value);
  }

  void _updatePinDisabled(bool value) {
    userInfo = userInfo.copyWith(pinDisabled: value);
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
    userInfo = userInfo.copyWith(isJustLogged: value);
  }

  void updateIsJustRegistered({required bool value}) {
    userInfo = userInfo.copyWith(isJustRegistered: value);
  }

  void _updateBiometric(bool hideBio) {
    userInfo = userInfo.copyWith(biometricDisabled: hideBio);
  }

  Future<void> disableBiometric() async {
    userInfo = userInfo.copyWith(biometricDisabled: true);

    await storage.setString(useBioKey, false.toString());
  }

  void updateTwoFaStatus({required bool enabled}) {
    _logger.log(notifier, 'updateTwoFaStatus');

    userInfo = userInfo.copyWith(twoFaEnabled: enabled);
  }

  void updatePhoneVerified({required bool phoneVerified}) {
    _logger.log(notifier, 'updatePhoneVerified');

    userInfo = userInfo.copyWith(phoneVerified: phoneVerified);
  }

  void updateEmailConfirmed({required bool emailConfirmed}) {
    _logger.log(notifier, 'updateEmailConfirmed');

    userInfo = userInfo.copyWith(emailConfirmed: emailConfirmed);
  }

  void updateChatClosed() {
    _logger.log(notifier, 'chatClosedOnThisSession');

    userInfo = userInfo.copyWith(chatClosedOnThisSession: true);
  }

  void updatePhoneConfirmed({required bool phoneConfirmed}) {
    _logger.log(notifier, 'updatePhoneConfirmed');

    userInfo = userInfo.copyWith(phoneConfirmed: phoneConfirmed);
  }

  void updateKycPassed({required bool kycPassed}) {
    _logger.log(notifier, 'updateKycPassed');

    userInfo = userInfo.copyWith(kycPassed: kycPassed);
  }

  void updateEmail(String email) {
    _logger.log(notifier, 'updateEmail');

    userInfo = userInfo.copyWith(email: email);
  }

  void updatePhone(String phone) {
    _logger.log(notifier, 'updatePhone');

    userInfo = userInfo.copyWith(phone: phone);
  }

  void clear() {
    userInfo = userInfo.copyWith(
      pin: null,
      phoneVerified: false,
      twoFaEnabled: false,
      emailConfirmed: false,
      phoneConfirmed: false,
      kycPassed: false,
      email: '',
      phone: '',
      countryOfRegistration: '',
      countryOfResidence: '',
      countryOfCitizenship: '',
      referralLink: '',
      referralCode: '',
      firstName: '',
      lastName: '',
    );
  }
}
