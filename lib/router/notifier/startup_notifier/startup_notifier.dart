import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../shared/helpers/navigate_to_router.dart';
import '../../../shared/logging/levels.dart';
import '../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../shared/providers/service_providers.dart';
import '../../provider/authorization_stpod/authorization_stpod.dart';
import '../../provider/authorization_stpod/authorization_union.dart';
import 'authorized_union.dart';
import 'startup_state.dart';

class StartupNotifier extends StateNotifier<StartupState> {
  StartupNotifier(this.read) : super(const StartupState());

  final Reader read;

  static final _logger = Logger('StartupNotifier');

  void _initSignalRSynchronously() {
    read(signalRServicePod).init();
  }

  Future<void> _processStartupState() async {
    if (read(authorizationStpod).state is Authorized) {
      try {
        final info = await read(infoServicePod).sessionInfo();

        read(userInfoNotipod.notifier).updateWithValuesFromSessionInfo(
          twoFaEnabled: info.twoFaEnabled,
          phoneVerified: info.phoneVerified,
        );

        _initSignalRSynchronously();

        if (info.emailVerified) {
          final profileInfo = await read(profileServicePod).info();

          read(userInfoNotipod.notifier).updateWithValuesFromProfileInfo(
            emailConfirmed: profileInfo.emailConfirmed,
            phoneConfirmed: profileInfo.phoneConfirmed,
            kycPassed: profileInfo.kycPassed,
            email: profileInfo.email ?? '',
            phone: profileInfo.phone ?? '',
            referralLink: profileInfo.referralLink ?? '',
            referralCode: profileInfo.referralCode ?? '',
            countryOfRegistration: profileInfo.countryOfRegistration ?? '',
          );
          if (!info.twoFaPassed) {
            _updateAuthorizedUnion(const TwoFaVerification());
          } else {
            _processPinState();
          }
        } else {
          _updateAuthorizedUnion(const EmailVerification());
        }
      } catch (e) {
        // TODO (discuss this flow)
        // In this case app will keep loading and nothing will happen
        // In order to retry user will need to reboot application
        _logger.log(stateFlow, 'Failed to fetch session info', e);
      }
    }
  }

  // [Start] Trigger AuthorizedUnion change ->
  /// Called when user is authenticated and makes cold boot
  void authenticatedBoot() {
    _logger.log(notifier, 'authenticatedBoot');

    _processStartupState();
  }

  /// Called after successfull authentication
  void successfullAuthentication() {
    _logger.log(notifier, 'successfullAuthentication');

    TextInput.finishAutofillContext(); // prompt to save credentials
    _updatefromLoginRegister(fromLoginRegister: true);
    _processStartupState().then((value) {
      /// Needed to dissmis Register/Login pushed screens
      navigateToRouter(read);
    });
  }

  /// Called after successfull email verification
  void emailVerified() {
    _logger.log(notifier, 'emailVerified');

    _processStartupState();
  }

  /// Called when user makes cold boot and has enabled 2FA
  /// and it was verified successfully
  void twoFaVerified() {
    _logger.log(notifier, 'twoFaVerified');

    _processPinState();
  }

  /// Called after 2FA when user login or register
  void pinSet() {
    _logger.log(notifier, 'pinSet');

    _updateAuthorizedUnion(const Home());
  }

  /// Called after 2FA when user is authenticated and makes cold boot
  void pinVerified() {
    _logger.log(notifier, 'pinVerified');

    _updateAuthorizedUnion(const Home());
  }
  // <- Trigger AuthorizedUnion change [End]

  void _processPinState() {
    final userInfo = read(userInfoNotipod);

    if (userInfo.pinEnabled) {
      _updateAuthorizedUnion(const PinVerification());
    } else {
      if (state.fromLoginRegister || !userInfo.pinDisabled) {
        _updateAuthorizedUnion(const PinSetup());
      } else {
        _updateAuthorizedUnion(const Home());
      }
    }
  }

  void _updateAuthorizedUnion(AuthorizedUnion union) {
    state = state.copyWith(authorized: union);
  }

  void _updatefromLoginRegister({required bool fromLoginRegister}) {
    state = state.copyWith(fromLoginRegister: fromLoginRegister);
  }
}
