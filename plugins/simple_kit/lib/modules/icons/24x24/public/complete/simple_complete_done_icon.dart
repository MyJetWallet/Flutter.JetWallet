import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../light/complete/simple_light_complete_done_icon.dart';

class SCompleteDoneIcon extends StatelessObserverWidget {
  const SCompleteDoneIcon({Key? key}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightCompleteDoneIcon()
        : const SimpleLightCompleteDoneIcon();
  }
}
