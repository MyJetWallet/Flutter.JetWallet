import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../shared/helpers/refresh_token.dart';
import '../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../shared/providers/service_providers.dart';
import '../../shared/services/local_storage_service.dart';
import '../notifier/startup_notifier/startup_notipod.dart';
import 'authorization_stpod/authorization_stpod.dart';
import 'authorization_stpod/authorization_union.dart';

final appInitFpod = FutureProvider<void>(
  (ref) async {
    final router = ref.watch(authorizationStpod.notifier);
    final authInfoN = ref.watch(authInfoNotipod.notifier);
    final userInfoN = ref.watch(userInfoNotipod.notifier);
    final storageService = ref.watch(localStorageServicePod);

    final token = await storageService.getString(refreshTokenKey);
    final email = await storageService.getString(userEmailKey);

    if (token == null) {
      router.state = const Unauthorized();
    } else {
      authInfoN.updateRefreshToken(token);
      authInfoN.updateEmail(email ?? '<Email not found>');

      try {
        final result = await refreshToken(ref.read);

        if (result == RefreshTokenStatus.success) {
          await userInfoN.initPinStatus();

          router.state = const Authorized();

          ref.read(startupNotipod.notifier).authenticatedBoot();
        } else {
          router.state = const Unauthorized();
        }
      } catch (e) {
        router.state = const Unauthorized();
      }
    }
  },
  name: 'appInitFpod',
);
