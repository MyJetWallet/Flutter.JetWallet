import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/components/bottom_tabs/bottom_tabs.dart';
import '../../../../../shared/components/bottom_tabs/components/bottom_tab.dart';
import '../../../../market/provider/market_crypto_pod.dart';
import '../../../../market/provider/market_currencies_indices_pod.dart';
import '../../../../market/provider/market_fiats_pod.dart';
import 'components/portfolio_with_balance_body.dart';

class PortfolioWithBalance extends StatefulHookWidget {
  const PortfolioWithBalance({Key? key}) : super(key: key);

  @override
  State<PortfolioWithBalance> createState() => _PortfolioWithBalanceState();
}

class _PortfolioWithBalanceState extends State<PortfolioWithBalance>
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
    final intl = useProvider(intlPod);

    final cryptosWithBalance = currenciesWithBalanceFrom(
      useProvider(marketCryptoPod),
    );
    final indicesWithBalance = currenciesWithBalanceFrom(
      useProvider(marketCurrenciesIndicesPod),
    );
    final fiatsWithBalance = currenciesWithBalanceFrom(
      useProvider(marketFiatsPod),
    );
    final isCryptoVisible = cryptosWithBalance.isNotEmpty &&
        (indicesWithBalance.isNotEmpty || fiatsWithBalance.isNotEmpty);
    final isFiatVisible = fiatsWithBalance.isNotEmpty &&
        (indicesWithBalance.isNotEmpty || cryptosWithBalance.isNotEmpty);
    final isIndicesVisible = indicesWithBalance.isNotEmpty &&
        (fiatsWithBalance.isNotEmpty || cryptosWithBalance.isNotEmpty);
    final isAllTabsVisible = isCryptoVisible ||
        isFiatVisible || isIndicesVisible;

    return SPageFrame(
      bottomNavigationBar: BottomTabs(
        tabController: tabController,
        tabs: [
         if (isAllTabsVisible) BottomTab(text: intl.portfolioWithBalance_all),
         if (isCryptoVisible) BottomTab(text: intl.portfolioWithBalance_crypto),
         if (isIndicesVisible) BottomTab(text: intl.market_bottomTabLabel3),
         if (isFiatVisible) BottomTab(text: intl.portfolioWithBalance_fiat),
        ],
      ),
      child: PortfolioWithBalanceBody(
        tabController: tabController,
      ),
    );
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

    return tabsLength == 2 ? 1 : tabsLength;
  }
}
