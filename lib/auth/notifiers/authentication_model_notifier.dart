import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/services/authentication/model/authentication_model.dart';

class AuthenticationModelNotifier extends StateNotifier<AuthenticationModel> {
  AuthenticationModelNotifier()
      : super(
          const AuthenticationModel(
            token: '',
            refreshToken: '',
            tradingUrl: '',
            connectionTimeOut: '',
            reconnectTimeOut: '',
          ),
        );

  void updateToken(String token) {
    state = state.copyWith(token: token);
  }

  void updateRefreshToken(String refreshToken) {
    state = state.copyWith(refreshToken: refreshToken);
  }

  void updateBothTokens(String token, String refreshToken) {
    state = state.copyWith(
      token: token,
      refreshToken: refreshToken,
    );
  }
}
