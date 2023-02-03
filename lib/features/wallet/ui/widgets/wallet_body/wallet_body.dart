import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_recurring_buy/action_recurring_buy.dart';
import 'package:jetwallet/features/actions/action_recurring_buy/action_with_out_recurring_buy.dart';
import 'package:jetwallet/features/actions/action_sell/action_sell.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/ui/widgets/fade_on_scroll.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/features/reccurring/ui/recurring_buy_banner.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/card_block/wallet_card.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/card_block/wallet_card_collapsed.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/supports_recurring_buy.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

const _collapsedCardHeight = 200.0;
const _expandedCardHeight = 270.0;

class WalletBody extends StatefulObserverWidget {
  const WalletBody({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<StatefulWidget> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;

    final recurring = getIt.get<RecurringBuysStore>();

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final filteredRecurringBuys = recurring.recurringBuysFiltred
        .where(
          (element) => element.toAsset == widget.currency.symbol,
        )
        .toList();

    final moveToRecurringInfo = filteredRecurringBuys.length == 1;

    final lastRecurringItem =
        filteredRecurringBuys.isNotEmpty ? filteredRecurringBuys[0] : null;

    const walletBackground = walletGreenBackgroundImageAsset;

    return Material(
      color: colors.white,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _snapAppbar();

          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colors.white,
              pinned: true,
              stretch: true,
              elevation: 0,
              expandedHeight: _expandedCardHeight,
              collapsedHeight: _collapsedCardHeight,
              automaticallyImplyLeading: false,
              primary: false,
              flexibleSpace: FadeOnScroll(
                scrollController: _scrollController,
                fullOpacityOffset: 33,
                fadeInWidget: WalletCardCollapsed(
                  currency: widget.currency,
                ),
                fadeOutWidget: WalletCard(
                  currency: widget.currency,
                ),
                permanentWidget: Stack(
                  children: [
                    SvgPicture.asset(
                      walletBackground,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    SPaddingH24(
                      child: SSmallHeader(
                        title: '${widget.currency.description}'
                            ' ${intl.walletBody_balance}',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SPaddingH24(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH36(),
                    Text(
                      '${widget.currency.description}'
                      ' ${intl.walletBody_transactions}',
                      style: sTextH4Style,
                    ),
                  ],
                ),
              ),
            ),
            TransactionsList(
              scrollController: _scrollController,
              symbol: widget.currency.symbol,
            ),
          ],
        ),
      ),
    );
  }

  void _snapAppbar() {
    const scrollDistance = _expandedCardHeight - _collapsedCardHeight;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
        () => _scrollController.animateTo(
          snapOffset.toDouble(),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
