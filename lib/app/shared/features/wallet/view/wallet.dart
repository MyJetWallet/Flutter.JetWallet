import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../shared/helpers/contains_single_element.dart';
import '../../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/non_indices_with_balance_from.dart';
import '../../../models/currency_model.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../provider/current_asset_pod.dart';
import 'components/action_button/action_button.dart';
import 'components/wallet_body/wallet_body.dart';

class Wallet extends StatefulHookWidget {
  const Wallet({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  static void push({
    required BuildContext context,
    required CurrencyModel currency,
  }) {
    navigatorPush(
      context,
      Wallet(
        currency: currency,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _WalletState();
}

class _WalletState extends State<Wallet>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    // animationController intentionally is not disposed,
    // because bottomSheet will dispose it on its own
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final itemsWithBalance = nonIndicesWithBalanceFrom(
      currenciesWithBalanceFrom(
        context.read(currenciesPod),
      ),
    );
    final initialPage = itemsWithBalance.indexOf(widget.currency);
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final currenciesWithBalance = nonIndicesWithBalanceFrom(
      currenciesWithBalanceFrom(currencies),
    );
    final currentAsset = useProvider(
      currentAssetStpod(widget.currency.symbol),
    );
    useListenable(_animationController);

    return Scaffold(
      bottomNavigationBar: ActionButton(
        transitionAnimationController: _animationController,
        currency: currentAsset.state,
      ),
      body: Material(
        color: Colors.transparent,
        child: SShadeAnimationStack(
          controller: _animationController,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  currentAsset.state = currenciesWithBalance[page];
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
                    padding: const EdgeInsets.only(top: 118),
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
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
