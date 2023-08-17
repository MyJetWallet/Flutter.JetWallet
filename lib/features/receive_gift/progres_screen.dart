import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'ProgressRouter')
class ProgressScreen extends StatelessObserverWidget {
  const ProgressScreen({super.key, required this.loading});

  final StackLoaderStore loading;

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
      loading: loading,
      customLoader: WaitingScreen(
        primaryText: intl.waitingScreen_processing,
        onSkip: () {},
      ),
      child: Container(),
    );
  }
}
