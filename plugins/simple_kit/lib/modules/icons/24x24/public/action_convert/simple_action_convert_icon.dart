import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/action_convert/simple_light_action_convert_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionConvertIcon extends StatelessObserverWidget {
  const SActionConvertIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightActionConvertIcon()
        : const SimpleLightActionConvertIcon();
  }
}
