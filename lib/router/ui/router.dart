import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app/screens/navigation/ui/navigation.dart';
import '../../auth/ui/auth.dart';
import '../../service_providers.dart';
import '../../shared/components/loader.dart';
import '../providers/router_fpod.dart';
import '../providers/router_init_fpod.dart';
import '../providers/router_key_pod.dart';
import '../providers/router_stpod.dart';
import 'components/splash_screen.dart';

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
        key: key,
        body: SafeArea(
          child: future.when(
            data: (_) {
              return init.when(
                data: (_) {
                  return router.state.when(
                    authorised: () => Navigation(),
                    unauthorised: () => Authentication(),
                  );
                },
                loading: () => Loader(),
                error: (e, st) => Text('$e'),
              );
            },
            loading: () => SplashScreen(),
            error: (e, st) => Text('$e'),
          ),
        ),
      ),
    );
  }
}
