import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/action/simple_light_action_active_highlighted_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionActiveHighlightedIcon extends StatelessObserverWidget {
  const SActionActiveHighlightedIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightActionActiveHighlightedIcon()
        : const SimpleLightActionActiveHighlightedIcon();
  }
}
