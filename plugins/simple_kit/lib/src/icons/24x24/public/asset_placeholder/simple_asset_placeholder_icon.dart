import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/asset_placeholder/simple_light_asset_placeholder_icon.dart';

class SAssetPlaceholderIcon extends ConsumerWidget {
  const SAssetPlaceholderIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightAssetPlaceholderIcon();
    } else {
      return const SimpleLightAssetPlaceholderIcon();
    }
  }
}
