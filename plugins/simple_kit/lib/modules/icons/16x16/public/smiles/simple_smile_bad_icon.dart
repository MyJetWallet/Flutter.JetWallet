import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/16x16/light/smiles/simple_light_smile_bad_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SSmileBadIcon extends StatelessObserverWidget {
  const SSmileBadIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightSmileBadIcon()
        : const SimpleLightSmileBadIcon();
  }
}
