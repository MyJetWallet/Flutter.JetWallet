import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/tick/simple_tick_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class STickLongIcon extends StatelessObserverWidget {
  const STickLongIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? SimpleTickLongIcon(color: color) : SimpleTickLongIcon(color: color);
  }
}
