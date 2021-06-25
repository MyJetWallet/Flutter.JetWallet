import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/password_recovery/password_recovery_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../sign_in_up/notifier/credentials_notifier/credentials_notifier.dart';
import '../../sign_in_up/notifier/credentials_notifier/credentials_state.dart';
import 'reset_password_union.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordUnion> {
  ResetPasswordNotifier({
    required this.credentialsState,
    required this.credentialsNotifier,
    required this.authService,
    required this.routerKey,
  }) : super(const Input());

  final CredentialsState credentialsState;
  final CredentialsNotifier credentialsNotifier;
  final AuthenticationService authService;
  final GlobalKey<ScaffoldState> routerKey;

  static final _logger = Logger('ResetPasswordNotifier');

  Future<void> resetPassword(String token) async {
    _logger.log(notifier, 'resetPassword');

    final password = credentialsState.passwordController.text;

    try {
      final model = PasswordRecoveryRequestModel(
        password: password,
        token: token,
      );

      state = const Loading();

      await authService.recoverPassword(model);

      state = const Input();

      Navigator.popUntil(
        routerKey.currentContext!,
            (route) => route.isFirst == true,
      );

    } catch (e, st) {
      _logger.log(stateFlow, 'resetPassword', e);

      state = Input(e, st);
    }
  }
}
