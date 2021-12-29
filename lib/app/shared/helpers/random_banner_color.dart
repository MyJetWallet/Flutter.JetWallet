import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

const _maxInt = 3;
final _random = Random();

Color randomBannerColor(SimpleColors colors) {
  final mod = _random.nextInt(_maxInt) % 3;

  if (mod == 0) {
    return colors.violet;
  } else if (mod == 1) {
    return colors.blueLight;
  } else {
    return colors.yellowLight;
  }
}
