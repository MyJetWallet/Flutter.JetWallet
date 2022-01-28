import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

class SelfieIcon extends HookWidget {
  const SelfieIcon({Key? key}) : super(key: key);

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
