import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class ScrollingFrame extends StatelessObserverWidget {
  const ScrollingFrame({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
