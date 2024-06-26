import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/account_status/simple_light_account_verify_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAccountVerifyIcon extends StatelessObserverWidget {
  const SAccountVerifyIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAccountVerifyIcon()
        : const SimpleLightAccountVerifyIcon();
  }
}
