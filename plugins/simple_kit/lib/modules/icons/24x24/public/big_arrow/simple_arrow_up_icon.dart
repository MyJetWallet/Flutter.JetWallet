import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/big_arrow/simple_light_arrow_down.dart';
import 'package:simple_kit/modules/icons/24x24/light/big_arrow/simple_light_arrow_up.dart';
import 'package:simple_kit/utils/enum.dart';

class SArrowUpIcon extends StatelessObserverWidget {
  const SArrowUpIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightArrowUpIcon()
        : const SimpleLightArrowUpIcon();
  }
}

class SArrowDownIcon extends StatelessObserverWidget {
  const SArrowDownIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightArrowDownIcon(color: color)
        : SimpleLightArrowDownIcon(color: color);
  }
}
