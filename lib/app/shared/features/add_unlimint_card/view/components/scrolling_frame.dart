import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class ScrollingFrame extends HookWidget {
  const ScrollingFrame({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Expanded(
      child: ColoredBox(
        color: colors.grey5,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
