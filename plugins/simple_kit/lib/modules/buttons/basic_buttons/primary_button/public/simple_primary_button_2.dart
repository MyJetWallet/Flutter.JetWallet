import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';
import '../dark/simple_dark_primary_button_2.dart';
import '../light/simple_light_primary_button_2.dart';

class SPrimaryButton2 extends StatelessObserverWidget {
  const SPrimaryButton2({
    super.key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
    this.isLoading = false,
  });

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleDarkPrimaryButton2(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
            isLoading: isLoading,
          )
        : SimpleLightPrimaryButton2(
            active: active,
            name: name,
            onTap: onTap,
            icon: icon,
            isLoading: isLoading,
          );
  }
}
