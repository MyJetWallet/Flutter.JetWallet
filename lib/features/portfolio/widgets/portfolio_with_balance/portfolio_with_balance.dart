import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/portfolio/helper/market_currencies_indices.dart';
import 'package:jetwallet/features/portfolio/helper/market_fiats.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/market_crypto.dart';
import 'package:jetwallet/widgets/bottom_tabs/bottom_tabs.dart';
import 'package:jetwallet/widgets/bottom_tabs/components/bottom_tab.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/portfolio_with_balance_body.dart';

class PortfolioWithBalance extends StatefulObserverWidget {
  const PortfolioWithBalance({super.key});

  @override
  State<PortfolioWithBalance> createState() => _PortfolioWithBalanceState();
}

class _PortfolioWithBalanceState extends State<PortfolioWithBalance>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    final cryptosWithBalance = currenciesWithBalanceFrom(
      getMarketCrypto(sSignalRModules.currenciesList),
    );
    final indicesWithBalance = currenciesWithBalanceFrom(
      getMarketCurrencies(sSignalRModules.currenciesList),
    );
    final fiatsWithBalance = currenciesWithBalanceFrom(
      getMarketFiats(sSignalRModules.currenciesList),
    );

    tabController = getController();
  }

  TabController getController() {
    final showNFT = sSignalRModules.clientDetail.isNftEnable;

    return TabController(
      length: 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cryptosWithBalance = currenciesWithBalanceFrom(
      getMarketCrypto(sSignalRModules.currenciesList),
    );
    final indicesWithBalance = currenciesWithBalanceFrom(
      getMarketCurrencies(sSignalRModules.currenciesList),
    );
    final fiatsWithBalance = currenciesWithBalanceFrom(
      getMarketFiats(sSignalRModules.currenciesList),
    );

    final isCryptoVisible = cryptosWithBalance.isNotEmpty &&
        (indicesWithBalance.isNotEmpty || fiatsWithBalance.isNotEmpty);

    final isFiatVisible = fiatsWithBalance.isNotEmpty &&
        (indicesWithBalance.isNotEmpty || cryptosWithBalance.isNotEmpty);

    final isIndicesVisible = indicesWithBalance.isNotEmpty &&
        (fiatsWithBalance.isNotEmpty || cryptosWithBalance.isNotEmpty);

    final isAllTabsVisible =
        isCryptoVisible || isFiatVisible || isIndicesVisible;

    final showNFT = sSignalRModules.clientDetail.isNftEnable;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      bottomNavigationBar: showNFT
          ? BottomTabs(
              tabController: tabController,
              tabs: [
                BottomTab(text: intl.portfolioWithBalance_crypto),
              ],
            )
          : null,
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
