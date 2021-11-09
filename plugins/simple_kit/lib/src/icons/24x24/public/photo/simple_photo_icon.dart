import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/photo/simple_light_photo_icon.dart';

class SPhotoIcon extends ConsumerWidget {
  const SPhotoIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightPhotoIcon();
    } else {
      return const SimpleLightPhotoIcon();
    }
  }
}
