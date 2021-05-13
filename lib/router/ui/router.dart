import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../app/screens/navigation/ui/navigation.dart';

import '../../auth/ui/auth.dart';
import '../../shared/components/splash_screen.dart';
import '../state/providers/router_fpod.dart';
import '../state/providers/router_stpod.dart';

class AppRouter extends HookWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final router = useProvider(routerStpod);
    final fpod = useProvider(routerFpod);

    return Scaffold(
      backgroundColor: Colors.white,
      body: fpod.when(
        data: (_) {
          return router.state.when(
            authorised: () => Navigation(),
            unauthorised: () => Authentication(),
          );
        },
        loading: () => SplashScreen(),
        error: (e, st) => Text('$e'),
      ),
    );
  }
}
