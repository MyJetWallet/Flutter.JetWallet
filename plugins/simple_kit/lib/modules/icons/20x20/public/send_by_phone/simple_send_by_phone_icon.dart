import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/20x20/light/send_by_phone/simple_light_send_by_phone_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSendByPhoneIcon extends StatelessObserverWidget {
  const SSendByPhoneIcon({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightSendByPhoneIcon(color: color)
        : SimpleLightSendByPhoneIcon(color: color);
  }
}
