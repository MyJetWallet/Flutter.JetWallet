import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/buy_tab_body.dart';
import 'package:jetwallet/features/convert_flow/screens/convert_tab_body.dart';
import 'package:jetwallet/features/sell_flow/screens/sell_tab_body.dart';
import 'package:jetwallet/features/transfer_flow/screens/transfer_tab_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

enum AmountScreenTab { buy, sell, convert, transfer }

@RoutePage(name: 'AmountRoute')
class AmountScreen extends StatefulWidget {
  const AmountScreen({
    super.key,
    required this.tab,
    this.asset,
    this.card,
    this.simpleCard,
    this.account,
    this.fromCard,
    this.toCard,
    this.fromAccount,
    this.toAccount,
  });

  final AmountScreenTab tab;
  final CurrencyModel? asset;

  final CircleCard? card;
  final CardDataModel? simpleCard;
  final SimpleBankingAccount? account;

  // for transfer
  final CardDataModel? fromCard;
  final CardDataModel? toCard;
  final SimpleBankingAccount? fromAccount;
  final SimpleBankingAccount? toAccount;

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.tab.index,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging) return;

      switch (tabController.index) {
        case 0:
          sAnalytics.tapOnTheBuyButtonOnBSCSegmentScreen();
          break;
        case 1:
          sAnalytics.tapOnTheSellButtonOnBSCSegmentButton();
          break;
        case 2:
          sAnalytics.tapOnTheConvertButtonOnBSCSegmentButton();
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '',
          onBackButtonTap: () {
            switch (tabController.index) {
              case 0:
                sAnalytics.tapOnTheBackFromAmountScreenButton(
                  destinationWallet: widget.asset?.symbol ?? '',
                  pmType: widget.card != null
                      ? PaymenthMethodType.card
                      : widget.account?.isClearjuctionAccount ?? false
                          ? PaymenthMethodType.cjAccount
                          : PaymenthMethodType.unlimitAccount,
                  buyPM: widget.card != null
                      ? 'Saved card ${widget.card?.last4}'
                      : widget.account?.isClearjuctionAccount ?? false
                          ? 'CJ  ${widget.account?.last4IbanCharacters}'
                          : 'Unlimint  ${widget.account?.last4IbanCharacters}',
                  sourceCurrency: 'EUR',
                );
                break;
              case 1:
                sAnalytics.tapOnTheBackFromSellAmountButton();
                break;
              case 2:
                sAnalytics.tapOnTheBackFromConvertAmountButton();
                break;
              default:
            }

            sRouter.pop();
          },
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SPaddingH24(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.grey5,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelColor: colors.white,
                    labelStyle: sSubtitle3Style,
                    unselectedLabelColor: colors.grey1,
                    unselectedLabelStyle: sSubtitle3Style,
                    splashBorderRadius: BorderRadius.circular(16),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: intl.amount_screen_tab_buy,
                      ),
                      Tab(
                        text: intl.amount_screen_tab_sell,
                      ),
                      Tab(
                        text: intl.amount_screen_tab_convert,
                      ),
                      Tab(
                        text: intl.amount_screen_tab_transfer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                BuyAmountTabBody(
                  asset: widget.asset,
                  card: widget.card,
                  account: widget.account,
                ),
                SellAmountTabBody(
                  asset: widget.asset?.assetBalance != Decimal.zero ? widget.asset : null,
                  account: widget.account,
                  simpleCard: widget.simpleCard,
                ),
                ConvertAmountTabBody(
                  fromAsset: widget.tab != AmountScreenTab.buy ? widget.asset : null,
                  toAsset: widget.tab == AmountScreenTab.buy ? widget.asset : null,
                ),
                TransferAmountTabBody(
                  fromCard: widget.fromCard,
                  toCard: widget.toCard,
                  fromAccount: widget.fromAccount,
                  toAccount: widget.toAccount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
