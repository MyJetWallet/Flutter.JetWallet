import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/balance_in_process.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/portfolio_sliver_appbar.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/actual_in_progress_operation.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/portfolio_screen_gradient.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:simple_kit/simple_kit.dart';

class PortfolioBalance extends StatefulObserverWidget {
  const PortfolioBalance({super.key});

  @override
  State<PortfolioBalance> createState() => _PortfolioBalanceState();
}

class _PortfolioBalanceState extends State<PortfolioBalance> {
  ScrollController scrollController = ScrollController();

  bool lastStatus = true;

  @override
  void initState() {
    scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return scrollController.hasClients &&
        scrollController.offset > (220 - kToolbarHeight);
  }

  Widget _balanceInProgressIcon(
    CurrencyModel currency,
  ) {
    if (!currency.isSingleTypeInProgress) {
      return const SDepositTotalIcon();
    }
    if (currency.transfersInProcessTotal > Decimal.zero) {
      return const SDepositSendIcon();
    } else if (currency.earnInProcessTotal > Decimal.zero) {
      return const SDepositEarnIcon();
    } else if (currency.buysInProcessTotal > Decimal.zero) {
      return const SDepositBuyIcon();
    }

    return const SDepositTotalIcon();
  }

  String _balanceInProgressText(
    CurrencyModel currency,
  ) {
    if (currency.isSingleTypeInProgress) {
      return volumeFormat(
        decimal: currency.totalAmountInProcess,
        accuracy: currency.accuracy,
        symbol: currency.symbol,
        prefix: currency.prefixSymbol,
      );
    }

    return intl.portfolioWithBalanceBody_transactions;
  }

  String _balanceInProgressLeadText(
    CurrencyModel currency,
  ) {
    if (currency.isSingleTypeInProgress) {
      return actualInProcessOperationName(
        currency,
        intl.portfolioWithBalanceBody_send,
        intl.portfolioWithBalanceBody_earn,
        intl.portfolioWithBalanceBody_simplex,
      );
    }

    return '${counterOfOperationInProgressTransactions(currency)} ';
  }

  Future<void> _onScrollsToTop(ScrollsToTopEvent event) async {
    print('asd');

    await scrollController.animateTo(
      event.to,
      duration: event.duration,
      curve: event.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesList;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);

    return ScrollsToTop(
      onScrollsToTop: _onScrollsToTop,
      child: PortfolioScreenGradient(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  stretch: true,
                  elevation: 0,
                  expandedHeight: 240,
                  collapsedHeight: 116,
                  floating: true,
                  flexibleSpace: PortfolioSliverAppBar(
                    isShrink: _isShrink,
                  ),
                ),
              ],
            ),
            DraggableScrollableSheet(
              maxChildSize: 0.76,
              minChildSize: 0.605,
              initialChildSize: 0.605,
              builder: (context, sCon) => DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: Colors.white,
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  controller: sCon,
                  physics: const ClampingScrollPhysics(),
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH32(),
                    SPaddingH24(
                      child: Text(
                        intl.portfolioWithBalanceBody_my_assets,
                        style: sTextH4Style,
                      ),
                    ),
                    const SpaceH12(),
                    Observer(builder: (context) {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: itemsWithBalance.length,
                        //controller: sCon,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SWalletItem(
                                isBalanceHide: getIt<AppStore>().isBalanceHide,
                                decline: itemsWithBalance[index]
                                    .dayPercentChange
                                    .isNegative,
                                icon: SNetworkSvg24(
                                  url: itemsWithBalance[index].iconUrl,
                                ),
                                primaryText:
                                    itemsWithBalance[index].description,
                                amount: itemsWithBalance[index]
                                    .volumeBaseBalance(baseCurrency),
                                secondaryText: getIt<AppStore>().isBalanceHide
                                    ? itemsWithBalance[index].symbol
                                    : itemsWithBalance[index]
                                        .volumeAssetBalance,
                                onTap: () {},
                                removeDivider:
                                    index == itemsWithBalance.length - 1,
                                isPendingDeposit:
                                    itemsWithBalance[index].isPendingDeposit,
                              ),
                              if (itemsWithBalance[index].isPendingDeposit) ...[
                                BalanceInProcess(
                                  text: getIt<AppStore>().isBalanceHide
                                      ? itemsWithBalance[index].symbol
                                      : _balanceInProgressText(
                                          itemsWithBalance[index],
                                        ),
                                  leadText: _balanceInProgressLeadText(
                                    itemsWithBalance[index],
                                  ),
                                  removeDivider: itemsWithBalance[index] ==
                                      itemsWithBalance.last,
                                  icon: _balanceInProgressIcon(
                                    itemsWithBalance[index],
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
