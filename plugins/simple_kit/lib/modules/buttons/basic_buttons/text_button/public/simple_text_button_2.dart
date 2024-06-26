import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/dark/simple_dark_text_button_2.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/text_button/light/simple_light_text_button_2.dart';
import 'package:simple_kit/utils/enum.dart';

class STextButton2 extends StatelessObserverWidget {
  const STextButton2({
    super.key,
    this.icon,
    this.addPadding = false,
    this.autoSize = false,
    required this.active,
    required this.name,
    required this.onTap,
  });

  final Widget? icon;
  final bool addPadding;
  final bool autoSize;
  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleDarkTextButton2(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
            addPadding: addPadding,
            autoSize: autoSize,
          )
        : SimpleLightTextButton2(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
            addPadding: addPadding,
            autoSize: autoSize,
          );
  }
}
