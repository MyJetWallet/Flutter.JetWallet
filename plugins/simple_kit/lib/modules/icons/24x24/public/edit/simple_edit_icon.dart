import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/edit/simple_light_edit_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SEditIcon extends StatelessObserverWidget {
  const SEditIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleLightEditIcon(color: color) : SimpleLightEditIcon(color: color);
  }
}
