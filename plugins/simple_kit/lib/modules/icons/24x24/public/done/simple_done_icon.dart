import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/done/simple_light_done_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SDoneIcon extends StatelessObserverWidget {
  const SDoneIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightDoneIcon()
        : const SimpleLightDoneIcon();
  }
}
