import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/two_factor_auth/simple_light_two_factor_auth_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class STwoFactorAuthIcon extends StatelessObserverWidget {
  const STwoFactorAuthIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightTwoFactorAuthIcon()
        : const SimpleLightTwoFactorAuthIcon();
  }
}
