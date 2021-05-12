import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/auth_model.dart';

final authModelStpod = StateProvider<AuthModel>((ref) {
  return const AuthModel(
    token: '',
    refreshToken: '',
    tradingUrl: '',
    connectionTimeOut: '',
    reconnectTimeOut: '',
  );
});
