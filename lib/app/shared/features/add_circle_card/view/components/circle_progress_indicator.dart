import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleProgressIndicator extends HookWidget {
  const CircleProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      height: 4.0,
      color: colors.blue,
    );
  }
}
