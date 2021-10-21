import 'package:flutter_riverpod/flutter_riverpod.dart';

enum STheme { light, dark }

/// State provider for changing theme, defaults to lightTheme
/// All providers that depend on the current theme must listen for it
final currentThemeStpod = StateProvider<STheme>(
  (ref) {
    return STheme.light;
  },
  name: 'currentThemeStpod',
);
