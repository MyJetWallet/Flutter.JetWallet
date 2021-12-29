import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notifier/remote_config_notifier/remote_config_notipod.dart';
import '../../notifier/startup_notifier/startup_notipod.dart';
import '../app_init_fpod.dart';
import '../authorization_stpod/authorization_stpod.dart';
import 'router_union.dart';

final routerPod = Provider<RouterUnion>(
  (ref) {
    var union = const RouterUnion.loading();

    final remoteConfig = ref.watch(remoteConfigNotipod);

    remoteConfig.when(
      success: () {
        final appInit = ref.watch(appInitFpod);

        appInit.maybeWhen(
          data: (_) {
            final authorization = ref.watch(authorizationStpod);

            authorization.state.when(
              authorized: () {
                final startup = ref.watch(startupNotipod);

                startup.authorized.when(
                  loading: () {
                    union = const RouterUnion.loading();
                  },
                  emailVerification: () {
                    union = const RouterUnion.emailVerification();
                  },
                  twoFaVerification: () {
                    union = const RouterUnion.twoFaVerification();
                  },
                  pinSetup: () {
                    union = const RouterUnion.pinSetup();
                  },
                  pinVerification: () {
                    union = const RouterUnion.pinVerification();
                  },
                  home: () {
                    union = const RouterUnion.home();
                  },
                );
              },
              unauthorized: () {
                union = const RouterUnion.unauthorized();
              },
            );
          },
          orElse: () {
            union = const RouterUnion.loading();
          },
        );
      },
      loading: () {
        union = const RouterUnion.loading();
      },
    );

    return union;
  },
  name: 'routerPod',
);
