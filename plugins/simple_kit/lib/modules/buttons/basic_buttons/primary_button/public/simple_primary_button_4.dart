import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/light/simple_light_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

class SPrimaryButton4 extends StatelessObserverWidget {
  const SPrimaryButton4({
    super.key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
  });

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightPrimaryButton4(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          )
        : SimpleLightPrimaryButton4(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          );
  }
}
