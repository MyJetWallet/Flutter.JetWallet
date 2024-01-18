import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/ui/buy_tab_body.dart';
import 'package:jetwallet/features/convert_flow/screens/convert_tab_body.dart';
import 'package:jetwallet/features/sell_flow/screens/sell_tab_body.dart';
import 'package:jetwallet/features/transfer_flow/screens/transfer_tab_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/models/segment_control_data.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/segment_control.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

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

  int countOfTabs = 4;

  int _currentTabIndex = 0;

  @override
  void initState() {
    final isShowTransferTab = checkNeedForTransferTab();

    countOfTabs = isShowTransferTab ? 4 : 3;
    tabController = TabController(
      length: countOfTabs,
      vsync: this,
      initialIndex: min(widget.tab.index, countOfTabs),
    );

    _currentTabIndex = tabController.index;

    tabController.addListener(() {
      if (tabController.indexIsChanging) return;

      setState(() {
        _currentTabIndex = tabController.index;
      });

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

  bool checkNeedForTransferTab() {
    final cardsCount = sSignalRModules.bankingProfileData?.banking?.cards
            ?.where((element) => element.status == AccountStatusCard.active)
            .length ??
        0;

    var accountsCount = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where((element) => element.status == AccountStatus.active)
            .length ??
        0;

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    if (simpleAccount?.status == AccountStatus.active) {
      accountsCount++;
    }

    final summary = cardsCount + accountsCount;

    return summary > 1;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              case 3:
                sAnalytics.tapOnTheBackFromTransferAmountButton();
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
                child: SegmentControl(
                  tabController: tabController,
                  shrinkWrap: true,
                  items: [
                    SegmentControlData(
                      type: _currentTabIndex == 0 ? SegmentControlType.iconText : SegmentControlType.icon,
                      text: intl.amount_screen_tab_buy,
                      icon: Assets.svg.medium.add,
                    ),
                    SegmentControlData(
                      type: _currentTabIndex == 1 ? SegmentControlType.iconText : SegmentControlType.icon,
                      text: intl.amount_screen_tab_sell,
                      icon: Assets.svg.medium.remove,
                    ),
                    SegmentControlData(
                      type: _currentTabIndex == 2 ? SegmentControlType.iconText : SegmentControlType.icon,
                      text: intl.amount_screen_tab_convert,
                      icon: Assets.svg.medium.transfer,
                    ),
                    if (countOfTabs >= 4)
                      SegmentControlData(
                        type: _currentTabIndex == 3 ? SegmentControlType.iconText : SegmentControlType.icon,
                        text: intl.amount_screen_tab_transfer,
                        icon: Assets.svg.medium.altDeposit,
                      ),
                  ],
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
                  account: (widget.account?.isNotEmptyBalance ?? false) ? widget.account : null,
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
                if (countOfTabs >= 4)
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
