import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/state/providers/auth_model_stpod.dart';
import '../../../shared/source/services/local_storage_service.dart';
import '../union/router_union.dart';
import 'router_stpod.dart';

final routerFpod = FutureProvider<void>((ref) async {
  final router = ref.read(routerStpod);
  final authModel = ref.read(authModelStpod);

  final token = await LocalStorageService.getString(tokenKey);

  if (token == null) {
    router.state = const Unauthorised();
  } else {
    authModel.state = authModel.state.copyWith(token: token);
    router.state = const Authorised();
  }
});
