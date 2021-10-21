import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../current_theme_stpod.dart';
import '../view/simple_colors.dart';
import '../view/simple_colors_dark.dart';
import '../view/simple_colors_light.dart';

/// Provides global color theme of the app
final sColorPod = Provider<SimpleColors>(
  (ref) {
    final theme = ref.watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return SColorsDark();
    } else {
      return SColorsLight();
    }
  },
  name: 'simpleColorPod',
);
