import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../service/services/authentication/model/forgot_password/forgot_password_request_model.dart';
import '../../../../service/services/authentication/service/authentication_service.dart';
import '../../../../service/shared/constants.dart';
import '../../../../shared/helpers/device_type.dart';
import '../../../shared/helpers/is_email_valid.dart';
import 'forgot_password_state.dart';
import 'forgot_password_union.dart';

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier({
    required this.authService,
  }) : super(const ForgotPasswordState());

  final AuthenticationService authService;

  static final _logger = Logger('ForgotPasswordNotifier');

  void updateEmail(String email) {
    _logger.log(notifier, 'updateEmail');

    state = state.copyWith(email: email);
  }

  void validateEmail() {
    _logger.log(notifier, 'validateEmail');

    if (isEmailValid(state.email)) {
      state = state.copyWith(emailValid: true);
    } else {
      state = state.copyWith(emailValid: false);
    }
  }

  void updateAndValidateEmail(String email) {
    state = state.copyWith(union: const Input());

    updateEmail(email);
    validateEmail();
  }

  Future<void> sendRecoveryLink() async {
    _logger.log(notifier, 'sendRecoveryLink');

    try {
      state = state.copyWith(union: const Loading());

      final model = ForgotPasswordRequestModel(
        email: state.email,
        platformType: platformType,
        deviceType: deviceType,
      );

      await authService.forgotPassword(model);

      state = state.copyWith(union: const Input());
    } catch (e) {
      _logger.log(stateFlow, 'sendRecoveryLink', e);

      state = state.copyWith(union: Error(e));
    }
  }

  bool get emailIsNotEmpty {
    return state.email.isNotEmpty;
  }
}
