import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/forgot_password/forgot_password_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../../../service/shared/constants.dart';
import '../../../../shared/helpers/device_type.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_notifier.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_state.dart';
import 'forgot_password_union.dart';

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordUnion> {
  ForgotPasswordNotifier({
    required this.credentials,
    required this.credentialsN,
    required this.authService,
  }) : super(const Input());

  final CredentialsState credentials;
  final CredentialsNotifier credentialsN;
  final AuthenticationService authService;

  static final _logger = Logger('ForgotPasswordNotifier');

  Future<void> sendRecoveryLink() async {
    _logger.log(notifier, 'sendRecoveryLink');

    try {
      final model = ForgotPasswordRequestModel(
        email: credentials.email,
        platformType: platformType,
        deviceType: deviceType,
      );

      state = const Loading();

      await authService.forgotPassword(model);

      state = const Input();
      // credentialsNotifier.clear();
    } catch (e, st) {
      _logger.log(stateFlow, 'sendRecoveryLink', e);

      state = Input(e, st);
    }
  }
}
