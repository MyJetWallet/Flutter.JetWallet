import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/utils/enum.dart';

import '../../light/gift_send/simple_light_gift_send_icon.dart';

class SGiftSendIcon extends StatelessObserverWidget {
  const SGiftSendIcon({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightGiftSendIcon(color: color)
        : SimpleLightGiftSendIcon(color: color);
  }
}
