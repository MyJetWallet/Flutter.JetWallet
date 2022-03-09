import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class DepositInfo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      width: double.infinity,
      color: colors.blueLight,
      height: 88.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Text(
            'Ensure the network you choose to deposit matches the '
            'withdrawal network',
            maxLines: 3,
            textAlign: TextAlign.center,
            style: sBodyText1Style,
          ),
        ),
      ),
    );
  }
}
