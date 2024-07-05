import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/action_send/simple_light_action_send_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SActionSendIcon extends StatelessObserverWidget {
  const SActionSendIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightActionSendIcon() : const SimpleLightActionSendIcon();
  }
}
