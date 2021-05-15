import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/services/authentication/model/authentication_model.dart';

final authenticationModelStpod = StateProvider<AuthenticationModel>((ref) {
  return const AuthenticationModel(
    token: '',
    refreshToken: '',
    tradingUrl: '',
    connectionTimeOut: '',
    reconnectTimeOut: '',
  );
});
