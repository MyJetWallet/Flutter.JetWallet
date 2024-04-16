import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/40x40/light/user/simple_light_user_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SUserTopIcon extends StatelessObserverWidget {
  const SUserTopIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightUserIcon() : const SimpleLightUserIcon();
  }
}
