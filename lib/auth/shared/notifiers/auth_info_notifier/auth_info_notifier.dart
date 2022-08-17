import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import 'auth_info_state.dart';

class AuthInfoNotifier extends StateNotifier<AuthInfoState> {
  AuthInfoNotifier() : super(const AuthInfoState());

  static final _logger = Logger('AuthModelNotifier');

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
