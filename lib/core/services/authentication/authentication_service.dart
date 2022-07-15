import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/authentication/models/auth_info_state.dart';
import 'package:jetwallet/utils/loggind.dart';
import 'package:logging/logging.dart';

@singleton
class AuthenticationService {
  AuthInfoState authState = const AuthInfoState();

  static final _logger = Logger('AuthModelNotifier');

  void updateToken(String token) {
    _logger.log(notifier, 'updateToken');

    authState = authState.copyWith(token: token);
  }

  void updateRefreshToken(String refreshToken) {
    _logger.log(notifier, 'updateRefreshToken');

    authState = authState.copyWith(refreshToken: refreshToken);
  }

  void updateEmail(String email) {
    _logger.log(notifier, 'updateEmail');

    authState = authState.copyWith(email: email);
  }

  void updateDeleteToken(String deleteToken) {
    _logger.log(notifier, 'deleteToken');

    authState = authState.copyWith(deleteToken: deleteToken);
  }

  /// Whether to show ResendButton in EmailVerification Screen at first open
  void updateResendButton() {
    _logger.log(notifier, 'updateResendButton');

    authState = authState.copyWith(
      showResendButton: !authState.showResendButton,
    );
  }

  /// Resets ResendButton state to the default one
  void resetResendButton() {
    _logger.log(notifier, 'resetResendButton');

    authState = authState.copyWith(showResendButton: true);
  }
}
