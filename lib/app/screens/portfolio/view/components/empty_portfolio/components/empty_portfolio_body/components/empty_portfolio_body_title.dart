import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../../../../helper/max_currency_apy.dart';

class EmptyPortfolioBodyTitle extends HookWidget {
  const EmptyPortfolioBodyTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: intl.emptyPortfolioBodyTitle_earn,
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
