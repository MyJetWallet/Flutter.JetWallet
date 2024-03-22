import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';
import '../light/simple_light_primary_button_3.dart';

class SPrimaryButton3 extends StatelessObserverWidget {
  const SPrimaryButton3({
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
        ? SimpleLightPrimaryButton3(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          )
        : SimpleLightPrimaryButton3(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          );
  }
}
