import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../model/auth_model.dart';

class AuthModelNotifier extends StateNotifier<AuthModel> {
  AuthModelNotifier()
      : super(
          const AuthModel(
            token: '',
            refreshToken: '',
            publicKeyPem: '',
            email: '',
          ),
        );

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
}
