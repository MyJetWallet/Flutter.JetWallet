import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/support/simple_light_support_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSupportIcon extends StatelessObserverWidget {
  const SSupportIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightSupportIcon()
        : const SimpleLightSupportIcon();
  }
}
