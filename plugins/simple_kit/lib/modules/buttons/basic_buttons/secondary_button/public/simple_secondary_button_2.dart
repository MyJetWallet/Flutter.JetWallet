import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';
import '../dark/simple_dark_secondary_button_2.dart';
import '../light/simple_light_secondary_button_2.dart';

class SSecondaryButton2 extends StatelessObserverWidget {
  const SSecondaryButton2({
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
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleDarkSecondaryButton2(
            active: active,
            name: name,
            icon: icon,
            onTap: onTap,
          )
        : SimpleLightSecondaryButton2(
            active: active,
            name: name,
            icon: icon,
            onTap: onTap,
          );
  }
}
