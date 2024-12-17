import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';

@RoutePage(name: 'ProgressRouter')
class ProgressScreen extends StatelessObserverWidget {
  const ProgressScreen({super.key, required this.loading});

  final StackLoaderStore loading;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.loader_please_wait,
      loading: loading,
      customLoader: const WaitingScreen(),
      child: Container(),
    );
  }
}
