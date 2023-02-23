import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/dark/simple_dark_text_button_1.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/light/simple_light_text_button_1.dart';
import 'package:simple_kit/utils/enum.dart';

class STextButton1 extends StatelessObserverWidget {
  const STextButton1({
    Key? key,
    this.color,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final String name;
  final Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleDarkTextButton1(active: active, name: name, onTap: onTap)
        : SimpleLightTextButton1(active: active, name: name, onTap: onTap, color: color,);
  }
}
