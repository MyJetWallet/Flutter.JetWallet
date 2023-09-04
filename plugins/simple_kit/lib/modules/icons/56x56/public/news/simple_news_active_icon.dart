import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/news/simple_light_news_active_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SNewsActiveIcon extends StatelessObserverWidget {
  const SNewsActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightNewsActiveIcon()
        : const SimpleLightNewsActiveIcon();
  }
}
