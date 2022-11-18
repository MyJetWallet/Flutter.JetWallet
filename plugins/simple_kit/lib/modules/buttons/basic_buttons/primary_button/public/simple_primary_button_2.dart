import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';
import '../dark/simple_dark_primary_button_2.dart';
import '../light/simple_light_primary_button_2.dart';

class SPrimaryButton2 extends StatelessObserverWidget {
  const SPrimaryButton2({
    Key? key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleDarkPrimaryButton2(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          )
        : SimpleLightPrimaryButton2(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
          );
  }
}
