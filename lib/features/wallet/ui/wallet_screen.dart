import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/wallet_body.dart';
import 'package:jetwallet/utils/helpers/contains_single_element.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage(name: 'WalletRouter')
class Wallet extends StatefulObserverWidget {
  const Wallet({
    super.key,
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late PageController _pageController;
  late CurrencyModel currentAsset;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    final itemsWithBalance = nonIndicesWithBalanceFrom(
      currenciesWithBalanceFrom(
        sSignalRModules.currenciesList,
      ),
    );
    final initialPage = itemsWithBalance.indexOf(widget.currency);
    currentAsset = widget.currency;
    currentPage = initialPage;

    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool skeepOnPageChanged = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final currenciesWithBalance = nonIndicesWithBalanceFrom(
      currenciesWithBalanceFrom(currencies),
    );

    // These actions are required to handle navigation
    // if the order of assets is changed externally
    final supposedPage = currenciesWithBalance.indexWhere(
      (element) => element.symbol == currentAsset.symbol,
    );
    if (currentPage != supposedPage) {
      currentAsset = currenciesWithBalance.firstWhere(
        (element) => element.symbol == currentAsset.symbol,
      );
      currentPage = supposedPage;
      skeepOnPageChanged = true;
      _pageController.jumpToPage(supposedPage);
    }

    return Scaffold(
      body: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (page) {
                if (skeepOnPageChanged) {
                  skeepOnPageChanged = false;
                } else {
                  currentAsset = currenciesWithBalance[page];
                  currentPage = page;
                }
              },
              children: [
                for (final currency in currenciesWithBalance)
                  WalletBody(
                    key: Key(currency.symbol),
                    currency: currency,
                  ),
              ],
            ),
            if (!containsSingleElement(currenciesWithBalance))
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 265),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: currenciesWithBalance.length,
                    effect: ScrollingDotsEffect(
                      spacing: 2,
                      radius: 4,
                      dotWidth: 8,
                      dotHeight: 2,
                      maxVisibleDots: 11,
                      activeDotScale: 1,
                      dotColor: colors.black.withOpacity(0.1),
                      activeDotColor: colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
