import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/screens/navigation/view/navigation.dart';
import '../../auth/screens/welcome/view/welcome.dart';
import '../../service_providers.dart';
import '../../shared/components/loader.dart';
import '../provider/router_fpod.dart';
import '../provider/router_init_fpod.dart';
import '../provider/router_key_pod.dart';
import '../provider/router_stpod/router_stpod.dart';

class AppRouter extends HookWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerStpod);
    final future = useProvider(routerFpod);
    final init = useProvider(routerInitFpod);
    final key = useProvider(routerKeyPod);

    return ProviderScope(
      overrides: [
        intlPod.overrideWithValue(AppLocalizations.of(context)!),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        key: key,
        body: SafeArea(
          child: future.when(
            data: (_) {
              return init.when(
                data: (_) {
                  return router.state.when(
                    authorized: () => Navigation(),
                    unauthorized: () => Welcome(),
                    emailVerification: () => Container(),
                  );
                },
                loading: () => Loader(),
                error: (e, st) => Text('$e'),
              );
            },
            loading: () => Loader(),
            error: (e, st) => Text('$e'),
          ),
        ),
      ),
    );
  }
}
