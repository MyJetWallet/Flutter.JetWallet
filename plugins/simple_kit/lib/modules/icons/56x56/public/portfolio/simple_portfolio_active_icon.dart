import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/portfolio/simple_light_portfolio_active_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPortfolioActiveIcon extends StatelessObserverWidget {
  const SPortfolioActiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightPortfolioActiveIcon()
        : const SimpleLightPortfolioActiveIcon();
  }
}
