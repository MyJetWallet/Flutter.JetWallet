import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/smiles/simple_light_smile_bad_icon.dart';

class SSmileBadIcon extends ConsumerWidget {
  const SSmileBadIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSmileBadIcon();
    } else {
      return const SimpleLightSmileBadIcon();
    }
  }
}
