import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/auth_model.dart';

class AuthModelNotifier extends StateNotifier<AuthModel> {
  AuthModelNotifier()
      : super(
          const AuthModel(
            token: '',
            publicKeyPem: '',
          ),
        );

  void updateToken(String token) {
    state = state.copyWith(token: token);
  }
}
