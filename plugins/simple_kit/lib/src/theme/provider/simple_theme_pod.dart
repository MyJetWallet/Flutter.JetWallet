import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../current_theme_stpod.dart';
import '../view/simple_dark_theme.dart';
import '../view/simple_light_theme.dart';

/// Provides global theme of the app
final sThemePod = Provider<ThemeData>(
  (ref) {
    final theme = ref.watch(currentThemeStpod);

    if (theme.state == STheme.dark) {
      return sDarkTheme;
    } else {
      return sLightTheme;
    }
  },
  name: 'simpleThemePod',
);
