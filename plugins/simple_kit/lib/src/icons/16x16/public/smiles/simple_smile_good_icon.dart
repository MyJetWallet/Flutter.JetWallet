import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/smiles/simple_light_smile_good_icon.dart';

class SSmileGoodIcon extends ConsumerWidget {
  const SSmileGoodIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSmileGoodIcon();
    } else {
      return const SimpleLightSmileGoodIcon();
    }
  }
}
