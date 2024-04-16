import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/40x22/light/delete/simple_light_delete_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SDeleteIcon extends StatelessObserverWidget {
  const SDeleteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightDeleteIcon()
        : const SimpleLightDeleteIcon();
  }
}
