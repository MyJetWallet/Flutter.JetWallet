import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/screens/navigation/view/navigation.dart';
import '../../../auth/screens/email_verification/view/email_verification.dart';
import '../../../auth/screens/welcome/view/welcome.dart';
import '../../../shared/components/app_frame.dart';
import '../../../shared/components/loader.dart';
import '../../provider/app_init_fpod.dart';
import '../../provider/authorized_stpod/authorized_stpod.dart';
import '../../provider/router_stpod/router_stpod.dart';
import '../../provider/session_info_fpod.dart';
import '../../provider/signalr_init_fpod.dart';

/// Launches application goes after [RemoteConfigInit]
class AppInit extends HookWidget {
  const AppInit({Key? key}) : super(key: key);

  static const routeName = 'app_init';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerStpod);
    final appInit = useProvider(appInitFpod);
    final signalRInit = useProvider(signalRInitFpod);
    final authorized = useProvider(authorizedStpod);
    final sessionInfo = useProvider(sessionInfoFpod);

    return AppFrame(
      child: appInit.when(
        data: (_) {
          return router.state.when(
            authorized: () {
              return sessionInfo.when(
                data: (_) {
                  return authorized.state.when(
                    home: () {
                      return signalRInit.when(
                        data: (_) => Navigation(),
                        loading: () => const Loader(
                          color: Colors.green,
                        ),
                        error: (e, st) => Text('$e'),
                      );
                    },
                    emailVerification: () => const EmailVerification(),
                    initial: () => const Text('Initial'),
                  );
                },
                loading: () => const Loader(
                  color: Colors.purple,
                ),
                error: (e, st) => Text('$e'),
              );
            },
            unauthorized: () => Welcome(),
          );
        },
        loading: () => const Loader(
          color: Colors.red,
        ),
        error: (e, st) => Text('$e'),
      ),
    );
  }
}
