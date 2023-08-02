import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/portfolio/helper/max_currency_apy.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptyPortfolioBodyTitle extends StatelessObserverWidget {
  const EmptyPortfolioBodyTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: '',
            style: sTextH3Style.copyWith(
              color: colors.black,
            ),
          ),
          TextSpan(
            text: ' ${intl.emptyPortfolioBodyTitle_upTo} '
                '${maxCurrencyApy(currencies).toStringAsFixed(0)}%',
            style: sTextH3Style.copyWith(
              color: colors.green,
            ),
          ),
          TextSpan(
            text: ' ${intl.emptyPortfolioBodyTitle_interest}',
            style: sTextH3Style.copyWith(
              color: colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
