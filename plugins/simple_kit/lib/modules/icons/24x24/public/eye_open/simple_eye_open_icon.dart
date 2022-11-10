import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/eye_open/simple_light_eye_open_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SEyeOpenIcon extends StatelessObserverWidget {
  const SEyeOpenIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightEyeOpenIcon()
        : const SimpleLightEyeOpenIcon();
  }
}
