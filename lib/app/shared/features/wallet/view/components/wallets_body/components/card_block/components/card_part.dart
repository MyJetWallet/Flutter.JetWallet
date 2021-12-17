import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class CardPart extends HookWidget {
  const CardPart({
    Key? key,
    this.width = 62,
    required this.left,
  }) : super(key: key);

  final bool left;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      height: 280,
      width: width,
      decoration: BoxDecoration(
        color: colors.greenLight,
        borderRadius: left
            ? const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
      ),
      child: const SizedBox(),
    );
  }
}
