import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers/service_providers.dart';
import 'components/app_init.dart';
import 'components/remote_config_init.dart';

/// This widget is supposed to be the first one that will
/// be created at the app launch
class AppRouter extends HookWidget {
  const AppRouter({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    useProvider(intlPod.select((_) {}));

    return const RemoteConfigInit(
      child: AppInit(),
    );
  }
}
