import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../shared/helpers/navigate_to_router.dart';
import '../../../shared/logging/levels.dart';
import '../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../shared/providers/service_providers.dart';
import '../../provider/router_stpod/router_stpod.dart';
import '../../provider/router_stpod/router_union.dart';
import 'authorized_union.dart';
import 'startup_state.dart';

class StartupNotifier extends StateNotifier<StartupState> {
  StartupNotifier(this.read) : super(const StartupState());

  final Reader read;

  static final _logger = Logger('StartupNotifier');

  Future<void> _processStartupState() async {
    _updateAuthorizedUnion(const Loading());

    if (read(routerStpod).state is Authorized) {
      try {
        final info = await read(infoServicePod).sessionInfo();

        read(userInfoNotipod.notifier).updateWithValuesFromSessionInfo(
          twoFaEnabled: info.twoFaEnabled,
          phoneVerified: info.phoneVerified,
        );

        if (info.emailVerified) {
          if (info.phoneVerified) {
            if (info.twoFaRequired) {
              _updateAuthorizedUnion(const TwoFaVerification());
            } else {
              _processPinState();
            }
          } else {
            _updateAuthorizedUnion(const PhoneVerification());
          }
        } else {
          _updateAuthorizedUnion(const EmailVerification());
        }
      } catch (e) {
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
  void successfulAuthentication() {
    _logger.log(notifier, 'successfulAuthentication');

    navigateToRouter(read);
    _updatefromLoginRegister(fromLoginRegister: true);
    _processStartupState();
  }

  /// Called after successfull email verification
  void emailVerified() {
    _logger.log(notifier, 'emailVerified');

    navigateToRouter(read);
    _processStartupState();
  }

  /// Called after successfull phone verification
  void phoneVerified() {
    _logger.log(notifier, 'phoneVerified');

    navigateToRouter(read);
    _processPinState();
  }

  /// Called when user decided to quite phone verification screen
  void quitPhoneVerification() {
    _logger.log(notifier, 'quitPhoneVerification');

    navigateToRouter(read);
    _processPinState();
  }

  /// Called when user makes cold boot and has enabled 2FA 
  /// and it was verified successfully
  void twoFaVerified() {
    _logger.log(notifier, 'twoFaVerified');

    navigateToRouter(read);
    _processPinState();
  }

  /// Called after 2FA when user login or register
  void pinSet() {
    _logger.log(notifier, 'pinSet');

    navigateToRouter(read);
    _updateAuthorizedUnion(const Home());
  }

  /// Called after 2FA when user is authenticated and makes cold boot
  void pinVerified() {
    _logger.log(notifier, 'pinVerified');

    navigateToRouter(read);
    _updateAuthorizedUnion(const Home());
  }
  // <- Trigger AuthorizedUnion change [End]

  void _processPinState() {
    if (read(userInfoNotipod).pinEnabled) {
      _updateAuthorizedUnion(const PinVerification());
    } else {
      if (state.fromLoginRegister) {
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
