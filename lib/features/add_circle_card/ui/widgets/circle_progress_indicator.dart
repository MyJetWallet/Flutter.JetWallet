import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleProgressIndicator extends StatelessObserverWidget {
  const CircleProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      height: 4.0,
      color: colors.blue,
    );
  }
}
