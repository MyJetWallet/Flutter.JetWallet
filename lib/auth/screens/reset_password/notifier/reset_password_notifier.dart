import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/forgot_password/forgot_password_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../sign_in_up/notifier/credentials_notifier/credentials_state.dart';
import 'reset_password_union.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordUnion> {
  ResetPasswordNotifier({
    required this.credentialsState,
    required this.authService,
  }) : super(const Input());

  final CredentialsState credentialsState;
  final AuthenticationService authService;

  static final _logger = Logger('ResetPasswordNotifier');

  Future<void> resetPassword() async {
    _logger.log(notifier, 'resetPassword');

    final password = credentialsState.passwordController.text;

    try {

      state = const Loading();

      state = const Input();

    } catch (e, st) {
      _logger.log(stateFlow, 'sendRecoveryLink', e);

      state = Input(e, st);
    }
  }
}
