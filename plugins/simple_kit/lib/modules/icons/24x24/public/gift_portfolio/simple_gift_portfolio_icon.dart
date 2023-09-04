import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/gift_portfolio/simple_light_portfolio_gift_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SGiftPortfolioIcon extends StatelessObserverWidget {
  const SGiftPortfolioIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightGiftPortfolioIcon(color: color)
        : SimpleLightGiftPortfolioIcon(color: color);
  }
}
