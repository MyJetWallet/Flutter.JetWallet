import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';

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
  bool initSignaWasCall = false;

  void _initSignalRSynchronously() {
    read(signalRServicePod).init();
  }

  Future<void> _processStartupState() async {
    if (read(authorizationStpod).state is Authorized) {
      final intl = read(intlPod);

      try {
        final info = await read(checkSessionServicePod).sessionCheck(
          intl.localeName,
        );
        if(!initSignaWasCall) {
          _initSignalRSynchronously();
          initSignaWasCall = true;
        }
        if (info.toCheckSimpleKyc) {
          _updateAuthorizedUnion(const UserDataVerification());
        } else if (info.toSetupPin) {
          _updateAuthorizedUnion(const PinSetup());
        } else if (info.toCheckPin) {
          _updateAuthorizedUnion(const PinVerification());
        } else if (info.toCheckSelfie) {
          _updateAuthorizedUnion(const PinVerification());
        } else {
          _updateAuthorizedUnion(const PinSetup());
        }
      } catch (e) {
        _logger.log(stateFlow, 'Failed to fetch session info', e);
        _updateAuthorizedUnion(const SingleIn());
      }
    }
  }

  // [Start] Trigger AuthorizedUnion change ->
  /// Called when user is authenticated and makes cold boot
  void authenticatedBoot() {
    _logger.log(notifier, 'authenticatedBoot');
    _processStartupState();
  }

  // /// Called after successfull authentication
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
    sAnalytics.emailConfirmed();

    _processStartupState();
  }

  /// Called when user makes cold boot and has enabled 2FA
  /// and it was verified successfully
  void twoFaVerified() {
    _logger.log(notifier, 'twoFaVerified');

    _processPinState();
  }

  void pinSet() {
    _logger.log(notifier, 'pinSet');

    _updateAuthorizedUnion(const AskBioUsing());
  }

  void pinVerified() {
    _logger.log(notifier, 'pinVerified');
    _updateAuthorizedUnion(const Home());
  }


  void _processPinState() {
    final userInfo = read(userInfoNotipod);

    if (userInfo.pinEnabled) {
      _updateAuthorizedUnion(const PinVerification());
    } else {
      if (state.fromLoginRegister || !userInfo.pinDisabled) {
        _updateAuthorizedUnion(const PinSetup());
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
