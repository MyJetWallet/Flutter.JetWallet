import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class PortfolioDivider extends HookWidget {
  const PortfolioDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: SDivider(
        color: colors.grey3,
      ),
    );
  }
}
