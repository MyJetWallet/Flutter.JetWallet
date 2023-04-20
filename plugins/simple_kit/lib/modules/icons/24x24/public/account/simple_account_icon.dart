import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/account/simple_light_account_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAccountIcon extends StatelessObserverWidget {
  const SAccountIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAccountIcon()
        : const SimpleLightAccountIcon();
  }
}
