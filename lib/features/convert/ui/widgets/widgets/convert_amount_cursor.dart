import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class ConvertAmountCursor extends StatelessObserverWidget {
  const ConvertAmountCursor({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      width: 4.0,
      height: 36.0,
      color: colors.blue,
    );
  }
}

class ConvertAmountCursorPlaceholder extends StatelessWidget {
  const ConvertAmountCursorPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 4.0,
      height: 36.0,
    );
  }
}
