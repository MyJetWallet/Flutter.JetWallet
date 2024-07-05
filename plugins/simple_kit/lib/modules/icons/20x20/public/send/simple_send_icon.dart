import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/send/simple_light_send_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSendIcon extends StatelessObserverWidget {
  const SSendIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightSendIcon() : const SimpleLightSendIcon();
  }
}
