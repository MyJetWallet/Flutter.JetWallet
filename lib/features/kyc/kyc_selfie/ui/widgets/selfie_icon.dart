import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class SelfieIcon extends StatelessWidget {
  const SelfieIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 17.0,
        bottom: 17.0,
      ),
      child: SSelfieIcon(),
    );
  }
}
