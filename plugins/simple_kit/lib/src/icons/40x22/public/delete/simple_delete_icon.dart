import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/delete/simple_light_delete_icon.dart';

class SDeleteIcon extends ConsumerWidget {
  const SDeleteIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightDeleteIcon();
    } else {
      return const SimpleLightDeleteIcon();
    }
  }
}
