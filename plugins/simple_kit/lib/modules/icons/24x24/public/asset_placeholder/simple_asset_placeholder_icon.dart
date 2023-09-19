import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/asset_placeholder/simple_light_asset_placeholder_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SAssetPlaceholderIcon extends StatelessObserverWidget {
  const SAssetPlaceholderIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightAssetPlaceholderIcon()
        : const SimpleLightAssetPlaceholderIcon();
  }
}
