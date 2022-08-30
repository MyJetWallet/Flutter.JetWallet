import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import 'auth_info_state.dart';

class AuthInfoNotifier extends StateNotifier<AuthInfoState> {
  AuthInfoNotifier(this.read) : super(const AuthInfoState());

  static final _logger = Logger('AuthModelNotifier');
  final Reader read;

  Future<void> initSessionInfo() async {
    final intl = read(intlPod);
    final userInfo = read(userInfoNotipod.notifier);
    final info = await read(infoServicePod).sessionInfo(intl.localeName);
    final profileInfo = await read(profileServicePod).info(intl.localeName);
    userInfo.updateWithValuesFromSessionInfo(
      twoFaEnabled: info.twoFaEnabled,
      phoneVerified: info.phoneVerified,
      hasDisclaimers: info.hasDisclaimers,
      hasHighYieldDisclaimers: info.hasHighYieldDisclaimers,
    );
    userInfo.updateWithValuesFromProfileInfo(
        emailConfirmed: profileInfo.emailConfirmed,
        phoneConfirmed: profileInfo.phoneConfirmed,
        kycPassed: profileInfo.kycPassed,
        email: profileInfo.email ?? '',
        phone: profileInfo.phone ?? '',
        referralLink: profileInfo.referralLink ?? '',
        referralCode: profileInfo.referralCode ?? '',
        countryOfRegistration: profileInfo.countryOfRegistration ?? '',
        countryOfResidence: profileInfo.countryOfResidence ?? '',
        countryOfCitizenship: profileInfo.countryOfCitizenship ?? '',
        firstName: profileInfo.firstName ?? '',
        lastName: profileInfo.lastName ?? '',
    );
  }

  void updateToken(String token) {
    _logger.log(notifier, 'updateToken');

    state = state.copyWith(token: token);
  }

  void updateRefreshToken(String refreshToken) {
    _logger.log(notifier, 'updateRefreshToken');

    state = state.copyWith(refreshToken: refreshToken);
  }

  void updateEmail(String email) {
    _logger.log(notifier, 'updateEmail');

    state = state.copyWith(email: email);
  }

  void updateDeleteToken(String deleteToken) {
    _logger.log(notifier, 'deleteToken');

    state = state.copyWith(deleteToken: deleteToken);
  }
  void updateVerificationToken(String verificationToken) {
    _logger.log(notifier, 'updateVerificationToken');

    state = state.copyWith(verificationToken: verificationToken);
  }

  /// Whether to show ResendButton in EmailVerification Screen at first open
  void updateResendButton() {
    _logger.log(notifier, 'updateResendButton');

    state = state.copyWith(showResendButton: !state.showResendButton);
  }

  /// Resets ResendButton state to the default one
  void resetResendButton() {
    _logger.log(notifier, 'resetResendButton');

    state = state.copyWith(showResendButton: true);
  }
}
