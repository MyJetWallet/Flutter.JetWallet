import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionDetailsNameText extends HookWidget {
  const TransactionDetailsNameText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Text(
      text,
      style: sBodyText2Style.copyWith(
        color: colors.grey1,
      ),
    );
  }
}
