import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/features/currency_buy/view/curency_buy.dart';
import '../../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/empty_portfolio_body_header_text.dart';
import 'components/empty_portfolio_body_image.dart';

class EmptyPortfolioBody extends HookWidget {
  const EmptyPortfolioBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currency = currencyFrom(
      useProvider(currenciesPod),
      'BTC',
    );

    return Column(
      children: [
        const SpaceH36(),
        const EmptyPortfolioBodyImage(),
        const SpaceH56(),
        const EmptyPortfolioBodyHeaderText(),
        const SpaceH17(),
        Text(
          'Make a first trade and be rewarded',
          style: sBodyText1Style.copyWith(color: colors.grey1),
        ),
        const SpaceH30(),
        SPrimaryButton1(
          active: true,
          name: 'Buy bitcoin',
          onTap: () {
            navigatorPush(
              context,
              CurrencyBuy(
                currency: currency,
              ),
            );
          },
        ),
      ],
    );
  }
}
