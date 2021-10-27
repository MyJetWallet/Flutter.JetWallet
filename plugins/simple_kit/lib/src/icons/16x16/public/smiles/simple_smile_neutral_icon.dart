import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/smiles/simple_light_smile_neutral_icon.dart';

class SSmileNeutralIcon extends ConsumerWidget {
  const SSmileNeutralIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightSmileNeutralIcon();
    } else {
      return const SimpleLightSmileNeutralIcon();
    }
  }
}
