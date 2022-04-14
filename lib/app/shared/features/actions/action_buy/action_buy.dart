import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../currency_buy/view/curency_buy.dart';
import '../helpers/show_currency_search.dart';
import '../shared/components/action_bottom_sheet_header.dart';
import '../shared/notifier/action_search_notipod.dart';

void showBuyAction({
  bool navigatePop = true,
  required BuildContext context,
  required bool fromCard,
}) {
  final showSearch = showBuyCurrencySearch(
    context,
    fromCard: fromCard,
  );

  if (navigatePop) Navigator.pop(context); // close BasicBottomSheet from Menu
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: 'Choose asset to buy',
      showSearch: showSearch,
      onChanged: (String value) {
        context.read(actionSearchNotipod.notifier).search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionBuy(
        fromCard: fromCard,
      )
    ],
  );
}

class _ActionBuy extends HookWidget {
  const _ActionBuy({
    Key? key,
    required this.fromCard,
  }) : super(key: key);

  final bool fromCard;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final state = useProvider(actionSearchNotipod);

    return Column(
      children: [
        const SpaceH10(),
        SizedBox(
          height: 21,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 24,
                ),
                child: Baseline(
                  baseline: 11,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    fromCard
                        ? 'Buy from card'
                        : 'Buy with credit card or crypto',
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey3,
                    ),
                  ),
                ),
              ),
              const SpaceW10(),
              Expanded(
                child: SDivider(
                  color: colors.grey4,
                ),
              ),
            ],
          ),
        ),
        for (final currency in state.filteredCurrencies) ...[
          if (currency.supportsAtLeastOneBuyMethod)
            SMarketItem(
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              name: currency.description,
              price: marketFormat(
                prefix: baseCurrency.prefix,
                decimal: baseCurrency.symbol == currency.symbol
                    ? Decimal.one
                    : currency.currentPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: currency.symbol,
              last: currency == state.buyFromCardCurrencies.last,
              percent: currency.dayPercentChange,
              onTap: () {
                sAnalytics.buySellView(
                  ScreenSource.quickActions,
                  currency.description,
                );

                navigatorPushReplacement(
                  context,
                  CurrencyBuy(
                    currency: currency,
                    fromCard: fromCard,
                  ),
                );
              },
            ),
        ],
        if (!fromCard) ...[
          const SpaceH10(),
          SizedBox(
            height: 21,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 24,
                  ),
                  child: Baseline(
                    baseline: 11,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      'Buy with crypto',
                      style: sCaptionTextStyle.copyWith(
                        color: colors.grey3,
                      ),
                    ),
                  ),
                ),
                const SpaceW10(),
                Expanded(
                  child: SDivider(
                    color: colors.grey4,
                  ),
                ),
              ],
            ),
          ),
          for (final currency in state.filteredCurrencies) ...[
            if (!currency.supportsAtLeastOneBuyMethod)
              SMarketItem(
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                name: currency.description,
                price: marketFormat(
                  prefix: baseCurrency.prefix,
                  decimal: baseCurrency.symbol == currency.symbol
                      ? Decimal.one
                      : currency.currentPrice,
                  symbol: baseCurrency.symbol,
                  accuracy: baseCurrency.accuracy,
                ),
                ticker: currency.symbol,
                last: currency == state.filteredCurrencies.last,
                percent: currency.dayPercentChange,
                onTap: () {
                  sAnalytics.buySellView(
                    ScreenSource.quickActions,
                    currency.description,
                  );

                  navigatorPushReplacement(
                    context,
                    CurrencyBuy(
                      currency: currency,
                      fromCard: fromCard,
                    ),
                  );
                },
              ),
          ],
        ],
      ],
    );
  }
}
