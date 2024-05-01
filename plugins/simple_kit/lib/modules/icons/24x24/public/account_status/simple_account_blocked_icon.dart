import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/account_status/simple_light_account_blocked_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAccountBlockedIcon extends StatelessObserverWidget {
  const SAccountBlockedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAccountBlockedIcon()
        : const SimpleLightAccountBlockedIcon();
  }
}
