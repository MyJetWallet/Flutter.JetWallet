import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/colors/simple_colors.dart';
import 'package:simple_kit/modules/colors/simple_colors_dark.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/theme/simple_dark_theme.dart';
import 'package:simple_kit/modules/theme/simple_light_theme.dart';
import 'package:simple_kit/utils/enum.dart';

import 'di.dart';

part 'simple_kit.g.dart';

final sKit = sGetIt.get<SimpleKit>();

// ignore: library_private_types_in_public_api
class SimpleKit = _SimpleKitBase with _$SimpleKit;

abstract class _SimpleKitBase with Store {
  /// Value for changing theme, defaults to lightTheme
  @observable
  STheme currentTheme = STheme.light;
  @action
  setCurrentTheme(STheme value) => currentTheme = value;

  CupertinoThemeData getTheme() {
    return currentTheme == STheme.dark ? sDarkTheme : sLightTheme;
  }

  @computed
  SimpleColors get colors => currentTheme == STheme.dark ? SColorsDark() : SColorsLight();
}
