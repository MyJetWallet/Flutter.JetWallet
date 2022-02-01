import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../../helper/max_currency_apy.dart';

class EmptyPortfolioBodyHeaderText extends HookWidget {
  const EmptyPortfolioBodyHeaderText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Earn',
            style: sTextH3Style.copyWith(
              color: colors.black,
            ),
          ),
          TextSpan(
            text: ' up to ${maxCurrencyApy(currencies).toStringAsFixed(0)}%',
            style: sTextH3Style.copyWith(
              color: colors.green,
            ),
          ),
          TextSpan(
            text: ' interest',
            style: sTextH3Style.copyWith(
              color: colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
