import 'package:auto_route/annotations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_store.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_settings.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_widget.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/simple_card_circle_actions.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/helpers/non_indices_with_balance_from.dart';
import '../../app/store/app_store.dart';
import '../../buy_flow/ui/amount_screen.dart';

const _collapsedCardHeight = 200.0;
const _expandedCardHeight = 270.0;

@RoutePage(name: 'SimpleCardRouter')
class SimpleCardScreen extends StatefulObserverWidget {
  const SimpleCardScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SimpleCardScreenState();
}

class _SimpleCardScreenState extends State<SimpleCardScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool isTopPosition = true;

  bool silverCollapsed = false;
  bool _scrollingHasAlreadyOccurred = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 0) {
        if (!isTopPosition) {
          setState(() {
            isTopPosition = true;
          });
        }
      } else {
        if (isTopPosition) {
          setState(() {
            isTopPosition = false;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = sKit.colors;

    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final simpleCardStore = getIt.get<SimpleCardStore>();

    return Material(
      color: colors.white,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            if (!_scrollingHasAlreadyOccurred) {
              _scrollingHasAlreadyOccurred = true;
            }
          } else if (scrollNotification is ScrollEndNotification) {
            _snapAppbar();
          }

          return false;
        },
        child: Stack(
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: SpaceH120(),
                ),
                SliverToBoxAdapter(
                  child: CardWidget(
                    card: simpleCardStore.cardFull!,
                    cardSensitive: simpleCardStore.cardSensitiveData!,
                    isFrozen: simpleCardStore.isFrozen,
                    showDetails: simpleCardStore.showDetails,
                    onTap: () {
                      simpleCardStore.setShowDetails(!simpleCardStore.showDetails);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Center(
                      child: Text(
                        getIt<AppStore>().isBalanceHide
                          ? '***** ${eurCurrency.symbol}'
                          : volumeFormat(
                            decimal: simpleCardStore.card?.balance ?? Decimal.zero,
                            accuracy: eurCurrency.accuracy,
                            symbol: eurCurrency.symbol,
                          ),
                        style: sTextH2Style,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    child: SimpleCardActionButtons(
                      isDetailsShown: simpleCardStore.showDetails,
                      isFrozen: simpleCardStore.isFrozen,
                      isTerminateAvailable: false,
                      isAddCashAvailable: sSignalRModules.currenciesList.where((currency) {
                        return currency.assetBalance != Decimal.zero;
                      }).toList().isNotEmpty,
                      onAddCash: () {
                        showSellChooseAssetBottomSheet(
                          context: context,
                          isAddCash: true,
                          onChooseAsset: (currency) {
                            Navigator.of(context).pop();
                            sRouter.push(
                              AmountRoute(
                                tab: AmountScreenTab.sell,
                                asset: currency,
                                simpleCard: simpleCardStore.cardFull,
                              ),
                            );
                          },
                        );
                      },
                      onShowDetails: () {
                        simpleCardStore.setShowDetails(!simpleCardStore.showDetails);
                      },
                      onFreeze: () {
                        simpleCardStore.setFrozen(!simpleCardStore.isFrozen);
                      },
                      onSettings: () {
                        showCardSettings(context);
                      },
                      onTerminate: () {},
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SPaddingH24(
                    child: Text(
                      intl.wallet_transactions,
                      style: sTextH4Style,
                    ),
                  ),
                ),
                if (simpleCardStore.cardFull != null) ...[
                  TransactionsList(
                    scrollController: _scrollController,
                    symbol: simpleCardStore.cardFull!.currency,
                    accountId: simpleCardStore.cardFull!.cardId,
                    onItemTapLisener: (symbol) {

                    },
                  ),
                ] else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 40,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            smileAsset,
                            width: 48,
                            height: 48,
                          ),
                          Text(
                            intl.wallet_simple_account_empty,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: sSubtitle2Style.copyWith(
                              color: sKit.colors.grey2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(
                  child: SpaceH120(),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ColoredBox(
                color: colors.white,
                child: SPaddingH24(
                  child: SSmallHeader(
                    title: 'Simple ${intl.simple_card_card}',
                    subTitle: intl.simple_card_type_virtual,
                    titleStyle: sTextH5Style.copyWith(
                      color: sKit.colors.black,
                    ),
                    subTitleStyle: sBodyText2Style.copyWith(
                      color: sKit.colors.grey1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snapAppbar() {
    const scrollDistance = _expandedCardHeight - _collapsedCardHeight;

    if (_scrollController.offset > 0 && _scrollController.offset < scrollDistance) {
      final snapOffset = _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

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
