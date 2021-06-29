import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/forgot_password/forgot_password_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../sign_in_up/notifier/credentials_notifier/credentials_notifier.dart';
import '../../sign_in_up/notifier/credentials_notifier/credentials_state.dart';
import 'forgot_password_union.dart';

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordUnion> {
  ForgotPasswordNotifier({
    required this.credentialsState,
    required this.credentialsNotifier,
    required this.authService,
  }) : super(const Input());

  final CredentialsState credentialsState;
  final CredentialsNotifier credentialsNotifier;
  final AuthenticationService authService;

  static final _logger = Logger('ForgotPasswordNotifier');

  Future<void> sendRecoveryLink() async {
    _logger.log(notifier, 'sendRecoveryLink');

    final email = credentialsState.emailController.text;
    final deviceType = _deviceType();

    try {
      final model = ForgotPasswordRequestModel(
        email: email,
        platformType: 2,
        deviceType: deviceType,
      );

      state = const Loading();

      await authService.forgotPassword(model);

      state = const Input();
      credentialsNotifier.clear();
    } catch (e, st) {
      _logger.log(stateFlow, 'sendRecoveryLink', e);

      state = Input(e, st);
    }
  }

  String _deviceType() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return '';
    }
  }
}
