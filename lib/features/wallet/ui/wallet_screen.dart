import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/my_wallets/helper/currencies_for_my_wallet.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/eur_wallet_body.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/wallet_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';

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

    sAnalytics.cryptoFavouriteWalletScreen(
      openedAsset: widget.currency.symbol,
    );

    final currencies = currenciesForMyWallet(sSignalRModules.currenciesList);

    final initialPage = currencies.indexOf(widget.currency);
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

    final currencies = currenciesForMyWallet(sSignalRModules.currenciesList);

    // These actions are required to handle navigation
    // if the order of assets is changed externally
    final supposedPage = currencies.indexWhere(
      (element) => element.symbol == currentAsset.symbol,
    );
    if (currentPage != supposedPage) {
      currentAsset = currencies.firstWhere(
        (element) => element.symbol == currentAsset.symbol,
      );
      currentPage = supposedPage;
      skeepOnPageChanged = true;
      _pageController.jumpToPage(supposedPage);
    }

    return WillPopScope(
      onWillPop: () {
        sAnalytics.eurWalletSwipeBetweenWallets();
        sAnalytics.tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen(
          openedAsset: widget.currency.symbol,
        );

        return Future.value(true);
      },
      child: Scaffold(
        body: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  sAnalytics.eurWalletSwipeBetweenWallets();

                  if (skeepOnPageChanged) {
                    skeepOnPageChanged = false;
                  } else {
                    currentAsset = currencies[page];
                    currentPage = page;
                    sAnalytics.cryptoFavouriteWalletScreen(
                      openedAsset: currencies[page].symbol,
                    );
                  }
                },
                children: [
                  for (final currency in currencies)
                    currency.symbol == 'EUR'
                        ? EurWalletBody(
                            key: Key(currency.symbol),
                            pageController: _pageController,
                            pageCount: currencies.length,
                          )
                        : WalletBody(
                            key: Key(currency.symbol),
                            currency: currency,
                            pageController: _pageController,
                            pageCount: currencies.length,
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
