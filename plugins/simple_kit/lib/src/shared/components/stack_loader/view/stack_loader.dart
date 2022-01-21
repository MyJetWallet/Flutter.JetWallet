import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/src/shared/components/stack_loader/view/components/loader_success_container.dart';

import '../../../../../simple_kit.dart';
import 'components/loader_background.dart';
import 'components/loader_container.dart';

class StackLoader extends HookWidget {
  const StackLoader({
    Key? key,
    this.loadSuccess,
    required this.child,
    required this.loading,
  }) : super(key: key);

  final Widget child;
  final StackLoaderNotifier? loading;
  final StackLoaderNotifier? loadSuccess;

  @override
  Widget build(BuildContext context) {
    if (loading != null) useValueListenable(loading!);
    final loadingValue = loading?.value ?? false;

    if (loadSuccess != null) useValueListenable(loadSuccess!);
    final loadSuccessValue = loadSuccess?.value ?? false;

    return Stack(
      children: [
        child,
        if (loadingValue) ...[
          const LoaderBackground(),
          const LoaderContainer(),
        ],
        if (loadSuccessValue) ...[
          const LoaderBackground(),
          const LoaderSuccessContainer(),
        ],
      ],
    );
  }
}
