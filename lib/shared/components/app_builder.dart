import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/device_size_from.dart';
import '../providers/device_size/device_size_pod.dart';

class AppBuilder extends HookWidget {
  const AppBuilder(this.child);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useMemoized(() => MediaQuery.of(context));

    return ProviderScope(
      overrides: [
        deviceSizePod.overrideWithValue(
          deviceSizeFrom(mediaQuery.size.height),
        ),
      ],
      child: child ?? const SizedBox(),
    );
  }
}
