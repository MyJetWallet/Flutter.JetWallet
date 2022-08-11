import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class CountryProfileWarning extends HookWidget {
  const CountryProfileWarning({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    return Baseline(
      baseline: 38.0,
      baselineType: TextBaseline.alphabetic,
      child: SInfoIcon(
        color: colors.red,
      ),
    );
  }
}
