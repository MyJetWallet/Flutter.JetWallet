import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/delete_asset/simple_light_delete_asset.dart';
import 'package:simple_kit/utils/enum.dart';

class SDeleteAssetIcon extends StatelessObserverWidget {
  const SDeleteAssetIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightDeleteAssetIcon(color: color)
        : SimpleLightDeleteAssetIcon(color: color);
  }
}
