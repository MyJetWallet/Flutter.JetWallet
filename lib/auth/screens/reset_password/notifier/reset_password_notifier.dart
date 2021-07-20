import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/password_recovery/password_recovery_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../../../shared/helpers/navigate_to_router.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_notifier.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_state.dart';
import 'reset_password_union.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordUnion> {
  ResetPasswordNotifier({
    required this.credentials,
    required this.credentialsN,
    required this.authService,
    required this.navigatorKey,
  }) : super(const Input());

  final CredentialsState credentials;
  final CredentialsNotifier credentialsN;
  final AuthenticationService authService;
  final GlobalKey<NavigatorState> navigatorKey;

  static final _logger = Logger('ResetPasswordNotifier');

  Future<void> resetPassword(String token) async {
    _logger.log(notifier, 'resetPassword');

    final password = credentials.password;

    try {
      final model = PasswordRecoveryRequestModel(
        password: password,
        token: token,
      );

      state = const Loading();

      await authService.recoverPassword(model);

      state = const Input();

      navigateToRouter(navigatorKey);

      // credentialsNotifier.clear();
    } catch (e, st) {
      _logger.log(stateFlow, 'resetPassword', e);

      state = Input(e, st);
    }
  }
}
