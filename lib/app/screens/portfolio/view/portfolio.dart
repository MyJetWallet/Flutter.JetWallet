import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../shared/components/bottom_tabs/bottom_tabs.dart';
import '../../../shared/components/bottom_tabs/components/bottom_tab.dart';
import '../../../shared/helpers/is_balance_empty.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../market/provider/market_crypto_pod.dart';
import '../../market/provider/market_currencies_indices_pod.dart';
import '../../market/provider/market_fiats_pod.dart';
import 'components/empty_portfolio_body/empty_porfolio_body.dart';
import 'components/portfolio_with_balance/portfolio_with_balance_body.dart';
import 'components/portfolio_with_balance/portfolio_with_balance_header.dart';

class Portfolio extends StatefulHookWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    final cryptosWithBalance =
        currenciesWithBalanceFrom(context.read(marketCryptoPod));
    final indicesWithBalance =
        currenciesWithBalanceFrom(context.read(marketCurrenciesIndicesPod));
    final fiatsWithBalance =
        currenciesWithBalanceFrom(context.read(marketFiatsPod));
    final tabsLength = _tabsLength(
      cryptosWithBalance.isEmpty,
      indicesWithBalance.isEmpty,
      fiatsWithBalance.isEmpty,
    );

    tabController = TabController(length: tabsLength, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balanceEmpty = isBalanceEmpty(useProvider(currenciesPod));
    final cryptosWithBalance =
        currenciesWithBalanceFrom(useProvider(marketCryptoPod));
    final indicesWithBalance =
        currenciesWithBalanceFrom(useProvider(marketCurrenciesIndicesPod));
    final fiatsWithBalance =
        currenciesWithBalanceFrom(useProvider(marketFiatsPod));

    if (balanceEmpty) {
      return const SPageFrame(
        header: PortfolioWithBalanceHeader(
          emptyBalance: true,
        ),
        child: EmptyPortfolioBody(),
      );
    } else {
      return SPageFrame(
        header: const PortfolioWithBalanceHeader(),
        bottomNavigationBar: BottomTabs(
          tabController: tabController,
          tabs: [
            if (cryptosWithBalance.isNotEmpty ||
                indicesWithBalance.isNotEmpty ||
                fiatsWithBalance.isNotEmpty)
              const BottomTab(text: 'All'),
            if (cryptosWithBalance.isNotEmpty) const BottomTab(text: 'Crypto'),
            if (indicesWithBalance.isNotEmpty) const BottomTab(text: 'Indices'),
            if (fiatsWithBalance.isNotEmpty) const BottomTab(text: 'Fiat'),
          ],
        ),
        child: PortfolioWithBalanceBody(
          tabController: tabController,
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
