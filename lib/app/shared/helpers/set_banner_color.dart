import 'package:flutter/material.dart';

import '../../screens/market/view/components/market_banners/market_banners.dart';

Color Function() setBannerColor() {
  var index = 0;
  Color inner() {
    final color = bannersColor[index];
    index++;
    return color;
  }
  return inner;
}
