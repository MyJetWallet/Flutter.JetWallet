import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/actions/action_buy/widgets/buy_payment_currency.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/formatting/base/market_format.dart';
import '../../../../utils/helpers/currencies_helpers.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../actions/helpers/show_currency_search.dart';
import '../../../actions/store/action_search_store.dart';

@RoutePage(name: 'ChooseAssetRouter')
class ChooseAssetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchStore = getIt.get<ActionSearchStore>();
    searchStore.init();
    searchStore.refreshSearch();
    final showSearch = showBuyCurrencySearch(
      context,
      fromCard: true,
      searchStore: searchStore,
    );
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        searchStore.init();
        sortByBalanceAndWeight(searchStore.filteredCurrencies);
      },
    );

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.actionBuy_chooseAsset,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (showSearch) ...[
              SPaddingH24(
                child: SStandardField(
                  controller: TextEditingController(),
                  labelText: intl.actionBottomSheetHeader_search,
                  onChanged: (String value) {
                    searchStore.search(value);
                  },
                ),
              ),
              const SDivider(),
            ],
            Observer(
              builder: (context) {
                return _ActionBuy(
                  fromCard: true,
                  showRecurring: false,
                  searchStore: searchStore,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBuy extends StatelessObserverWidget {
  const _ActionBuy({
    required this.fromCard,
    required this.showRecurring,
    required this.searchStore,
  });

  final bool fromCard;
  final bool showRecurring;
  final ActionSearchStore searchStore;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = searchStore;

    sortByBalanceAndWeight(state.fCurrencies);

    void onItemTap(CurrencyModel currency, bool fromCard) {
      showBuyPaymentCurrencyBottomSheet(context, currency);
    }

    Widget marketItem(
      String iconUrl,
      String name,
      String price,
      String ticker,
      double percent,
      dynamic Function() onTap, {
      bool isLast = false,
    }) {
      return SMarketItem(
        icon: SNetworkSvg24(
          url: iconUrl,
        ),
        name: name,
        price: price,
        ticker: ticker,
        last: isLast,
        percent: percent,
        onTap: onTap,
      );
    }

    return Column(
      children: [
        for (final currency in state.fCurrencies) ...[
          if (currency.supportsAtLeastOneBuyMethod)
            marketItem(
              currency.iconUrl,
              currency.description,
              marketFormat(
                prefix: baseCurrency.prefix,
                decimal: baseCurrency.symbol == currency.symbol
                    ? Decimal.one
                    : currency.currentPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              currency.symbol,
              currency.dayPercentChange,
              () => onItemTap(currency, fromCard),
              isLast: currency ==
                  state.fCurrencies
                      .where(
                        (element) => element.supportsAtLeastOneBuyMethod,
                      )
                      .toList()
                      .last,
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
