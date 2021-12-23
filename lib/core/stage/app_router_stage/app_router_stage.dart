import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/view/components/remote_config_init.dart';
import '../../../shared/providers/service_providers.dart';
import 'api_selector_screen/view/api_selector_screen.dart';

/// [AppRouterStage] is used for stage environment only
class AppRouterStage extends HookWidget {
  const AppRouterStage({Key? key}) : super(key: key);

  static const routeName = '/app_router_stage';

  @override
  Widget build(BuildContext context) {
    useProvider(intlPod.select((_) {}));

    return const RemoteConfigInit(
      child: ApiSelectorScreen(),
    );
  }
}
