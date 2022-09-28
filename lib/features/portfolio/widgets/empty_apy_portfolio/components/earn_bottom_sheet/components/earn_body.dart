import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/earn_advantages.dart';
import 'components/earn_currencys_item.dart';

class EarnBody extends StatelessObserverWidget {
  const EarnBody({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function(CurrencyModel) onTap;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final sortedByApyCurrencies = currencies;

    sortByApyAndWeight(sortedByApyCurrencies);

    return Column(
      children: [
        const SPaddingH24(
          child: EarnAdvantages(),
        ),
        const SpaceH32(),
        const SPaddingH24(
          child: SDivider(),
        ),
        const SpaceH32(),
        SPaddingH24(
          child: Row(
            children: [
              Text(
                intl.earnBody_startEarn,
                style: sTextH4Style,
              ),
            ],
          ),
        ),
        const SpaceH24(),
        for (var element in sortedByApyCurrencies) ...[
          if (element.apy.toDouble() > 0)
            EarnCurrencyItem(
              element: element,
              onTap: () => onTap(element),
            ),
        ],
      ],
    );
  }
}
