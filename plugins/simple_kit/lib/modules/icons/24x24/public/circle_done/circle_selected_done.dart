import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/circle_done/circle_selected_done.dart';
import 'package:simple_kit/utils/enum.dart';

class SCircleDoneSelected extends StatelessObserverWidget {
  const SCircleDoneSelected({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightCircleDoneSelectedIcon(color: color)
        : SimpleLightCircleDoneSelectedIcon(color: color);
  }
}
