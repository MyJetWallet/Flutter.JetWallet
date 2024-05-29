import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';

import '../dark/simple_dark_primary_button_1.dart';
import '../light/simple_light_primary_button_1.dart';

class SPrimaryButton1 extends StatelessObserverWidget {
  const SPrimaryButton1({
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
        ? SimpleDarkPrimaryButton1(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          )
        : SimpleLightPrimaryButton1(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          );
  }
}
