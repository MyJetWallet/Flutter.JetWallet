import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/copy/simple_light_copy_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SCopyIcon extends StatelessObserverWidget {
  const SCopyIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightCopyIcon()
        : const SimpleLightCopyIcon();
  }
}
