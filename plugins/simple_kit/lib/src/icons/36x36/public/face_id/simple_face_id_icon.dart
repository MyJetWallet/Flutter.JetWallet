import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../current_theme_stpod.dart';
import '../../light/face_id/simple_light_face_id_icon.dart';

class SFaceIdIcon extends ConsumerWidget {
  const SFaceIdIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return const SimpleLightFaceIdIcon();
    } else {
      return const SimpleLightFaceIdIcon();
    }
  }
}
