import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

Color setBannerColor(int index, SimpleColors colors) {
  if (index % 3 == 0) {
    return colors.violet;
  } else if (index % 3 == 1) {
    return colors.blueLight;
  } else {
    return colors.yellowLight;
  }
}
