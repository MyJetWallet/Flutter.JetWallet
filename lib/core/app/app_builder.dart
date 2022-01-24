import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/helpers/device_size_from.dart';
import '../../shared/providers/device_size/device_size_pod.dart';

class AppBuilder extends HookWidget {
  const AppBuilder(this.child);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useMemoized(() => MediaQuery.of(context));
    // reactiveMediaQuery is needed to update viewInsets and
    // other stuff when it changes.
    // In the case above changes are unwanted, so we placed
    // mediaQuery inside useMemorized hook
    final reactiveMediaQuery = MediaQuery.of(context);

    return ProviderScope(
      overrides: [
        deviceSizePod.overrideWithValue(
          deviceSizeFrom(mediaQuery.size.height),
        ),
      ],
      child: MediaQuery(
        data: reactiveMediaQuery.copyWith(
          textScaleFactor: 1.0,
        ),
        child: child ?? const SizedBox(),
      ),
    );
  }
}
