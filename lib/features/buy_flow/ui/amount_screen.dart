import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/buy_tab_body.dart';
import 'package:jetwallet/features/buy_flow/ui/convert_tab_body.dart';
import 'package:jetwallet/features/buy_flow/ui/sell_tab_body.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

enum AmountScreenTab { buy, sell, convert }

@RoutePage(name: 'AmountRoute')
class AmountScreen extends StatefulWidget {
  const AmountScreen({
    super.key,
    required this.tab,
    required this.asset,
    this.card,
    this.simpleCard,
    this.account,
  });

  final AmountScreenTab tab;
  final CurrencyModel asset;

  final CircleCard? card;
  final CardDataModel? simpleCard;
  final SimpleBankingAccount? account;

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.tab.index,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '',
          onBackButtonTap: () => sRouter.pop(),
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
                  asset: widget.asset.assetBalance != Decimal.zero ? widget.asset : null,
                  account:  widget.account,
                ),
                ConvertAmountTabBody(
                  asset: widget.asset,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
