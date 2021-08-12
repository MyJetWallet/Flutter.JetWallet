import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/screens/navigation/view/navigation.dart';
import '../../auth/screens/email_verification/view/email_verification.dart';
import '../../auth/screens/welcome/view/welcome.dart';
import '../../shared/components/loader.dart';
import '../../shared/providers/service_providers.dart';
import '../provider/app_init_fpod.dart';
import '../provider/authorized_stpod/authorized_stpod.dart';
import '../provider/router_stpod/router_stpod.dart';
import '../provider/session_info_fpod.dart';
import '../provider/signalr_init_fpod.dart';

/// This widget is supposed to be the first one that will
/// be created at the app launch
class AppRouter extends HookWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerStpod);
    final appInit = useProvider(appInitFpod);
    final signalRInit = useProvider(signalRInitFpod);
    final authorized = useProvider(authorizedStpod);
    final sessionInfo = useProvider(sessionInfoFpod);
    useProvider(intlPod.select((_) {}));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  loading: () => const Loader(),
                  error: (e, st) => Text('$e'),
                );
              },
              unauthorized: () => Welcome(),
            );
          },
          loading: () => const Loader(),
          error: (e, st) => Text('$e'),
        ),
      ),
    );
  }
}
