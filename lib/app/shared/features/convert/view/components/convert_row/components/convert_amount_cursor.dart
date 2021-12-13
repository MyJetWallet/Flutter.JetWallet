import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class ConvertAmountCursor extends HookWidget {
  const ConvertAmountCursor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      width: 4.0,
      height: 36.0,
      color: colors.blue,
    );
  }
}

class ConvertAmountCursorPlaceholder extends StatelessWidget {
  const ConvertAmountCursorPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 4.0,
      height: 36.0,
    );
  }
}
