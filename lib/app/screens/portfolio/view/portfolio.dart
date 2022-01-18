import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../shared/components/bottom_tabs/bottom_tabs.dart';
import '../../../shared/components/bottom_tabs/components/bottom_tab.dart';
import '../../../shared/helpers/is_balance_empty.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../market/provider/market_cryptos_pod.dart';
import '../../market/provider/market_currencies_indices_pod.dart';
import '../../market/provider/market_fiats_pod.dart';
import 'components/empty_portfolio_body/empty_porfolio_body.dart';
import 'components/portfolio_with_balance/portfolio_with_balance_body.dart';
import 'components/portfolio_with_balance/portfolio_with_balance_header.dart';

class Portfolio extends HookWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceEmpty = isBalanceEmpty(useProvider(currenciesPod));
    final cryptosWithBalance =
        currenciesWithBalanceFrom(useProvider(marketCryptosPod));
    final indicesWithBalance =
        currenciesWithBalanceFrom(useProvider(marketCurrenciesIndicesPod));
    final fiatsWithBalance =
        currenciesWithBalanceFrom(useProvider(marketFiatsPod));
    final tabsLength = _tabsLength(
      cryptosWithBalance.isEmpty,
      indicesWithBalance.isEmpty,
      fiatsWithBalance.isEmpty,
    );

    if (balanceEmpty) {
      return const SPageFrameWithPadding(
        header: SSmallHeader(
          title: 'Balance',
          showBackButton: false,
        ),
        child: EmptyPortfolioBody(),
      );
    } else {
      return DefaultTabController(
        length: tabsLength,
        child: SPageFrame(
          header: const PortfolioWithBalanceHeader(),
          bottomNavigationBar: BottomTabs(
            tabs: [
              if (cryptosWithBalance.isNotEmpty ||
                  indicesWithBalance.isNotEmpty ||
                  fiatsWithBalance.isNotEmpty)
                const BottomTab(text: 'All'),
              if (cryptosWithBalance.isNotEmpty)
                const BottomTab(text: 'Crypto'),
              if (indicesWithBalance.isNotEmpty)
                const BottomTab(text: 'Indices'),
              if (fiatsWithBalance.isNotEmpty) const BottomTab(text: 'Fiat'),
            ],
          ),
          child: PortfolioWithBalanceBody(
            tabsLength: tabsLength,
          ),
        ),
      );
    }
  }

  int _tabsLength(
    bool cryptosEmpty,
    bool indicesEmpty,
    bool fiatsEmpty,
  ) {
    var tabsLength = 4;

    if (cryptosEmpty) {
      tabsLength--;
    }
    if (indicesEmpty) {
      tabsLength--;
    }
    if (fiatsEmpty) {
      tabsLength--;
    }

    return tabsLength;
  }
}
