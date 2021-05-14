import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/services/auth/model/authentication/auth_model.dart';

final authModelStpod = StateProvider<AuthModel>((ref) {
  return const AuthModel(
    token: '',
    refreshToken: '',
    tradingUrl: '',
    connectionTimeOut: '',
    reconnectTimeOut: '',
  );
});
