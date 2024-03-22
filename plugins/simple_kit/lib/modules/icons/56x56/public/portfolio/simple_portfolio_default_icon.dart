import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/56x56/light/portfolio/simple_light_portfolio_default_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPortfolioDefaultIcon extends StatelessObserverWidget {
  const SPortfolioDefaultIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? const SimpleLightPortfolioDefaultIcon()
        : const SimpleLightPortfolioDefaultIcon();
  }
}
