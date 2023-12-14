import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/list_checkmark/simple_light_check_list_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SCheckListIcon extends StatelessObserverWidget {
  const SCheckListIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightCheckListIcon(color: color)
        : SimpleLightCheckListIcon(color: color);
  }
}
