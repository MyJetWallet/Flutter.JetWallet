import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/lock/simple_light_lock_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SLockIcon extends StatelessObserverWidget {
  const SLockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightLockIcon()
        : const SimpleLightLockIcon();
  }
}
