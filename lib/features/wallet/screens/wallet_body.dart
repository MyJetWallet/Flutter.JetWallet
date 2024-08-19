import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:jetwallet/features/wallet/widgets/wallet_actions_row.dart';
import 'package:jetwallet/features/wallet/widgets/wallet_earn_section.dart';
import 'package:jetwallet/features/wallet/widgets/wallet_price_section.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

const _collapsedCardHeight = 200.0;
const _expandedCardHeight = 270.0;

class WalletBody extends StatefulObserverWidget {
  const WalletBody({
    super.key,
    required this.currency,
    this.pageController,
    this.pageCount,
    this.indexNow,
    this.isSinglePage = false,
  });

  final CurrencyModel currency;
  final PageController? pageController;
  final int? pageCount;
  final int? indexNow;
  final bool isSinglePage;

  @override
  State<StatefulWidget> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool isTopPosition = true;

  bool silverCollapsed = false;
  bool _scrollingHasAlreadyOccurred = false;

  bool showViewAllBoatonOnHistory = false;

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

    return Material(
      color: colors.white,
      child: Column(
        children: [
          CollapsedWalletAppbar(
            scrollController: _scrollController,
            assetIcon: SNetworkSvg24(
              url: widget.currency.iconUrl,
            ),
            ticker: widget.currency.symbol,
            mainTitle: widget.currency.symbol == 'EUR'
                ? getIt<AppStore>().isBalanceHide
                    ? '**** ${widget.currency.symbol}'
                    : sSignalRModules.totalEurWalletBalance.toFormatSum(
                        accuracy: widget.currency.accuracy,
                        symbol: widget.currency.symbol,
                      )
                : getIt<AppStore>().isBalanceHide
                    ? '**** ${getIt.get<FormatService>().baseCurrency.symbol}'
                    : widget.currency.volumeBaseBalance(
                        getIt.get<FormatService>().baseCurrency,
                      ),
            mainSubtitle: getIt.get<FormatService>().baseCurrency.symbol != widget.currency.symbol
                ? widget.currency.symbol == 'EUR'
                    ? getIt<AppStore>().isBalanceHide
                        ? '**** ${getIt.get<FormatService>().baseCurrency.symbol}'
                        : widget.currency.volumeBaseBalance(
                            getIt.get<FormatService>().baseCurrency,
                          )
                    : getIt<AppStore>().isBalanceHide
                        ? '******* ${widget.currency.symbol}'
                        : widget.currency.volumeAssetBalance
                : null,
            mainHeaderTitle: widget.currency.description,
            mainHeaderSubtitle: intl.eur_wallet,
            mainHeaderCollapsedTitle: widget.currency.symbol == 'EUR'
                ? getIt<AppStore>().isBalanceHide
                    ? '**** ${widget.currency.symbol}'
                    : sSignalRModules.totalEurWalletBalance.toFormatSum(
                        accuracy: widget.currency.accuracy,
                        symbol: widget.currency.symbol,
                      )
                : getIt<AppStore>().isBalanceHide
                    ? '**** ${getIt.get<FormatService>().baseCurrency.symbol}'
                    : widget.currency.volumeBaseBalance(
                        getIt.get<FormatService>().baseCurrency,
                      ),
            mainHeaderCollapsedSubtitle: widget.currency.description,
            carouselItemsCount: widget.pageCount,
            carouselPageIndex: widget.indexNow,
            needCarousel: !widget.isSinglePage,
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollStartNotification) {
                  if (!_scrollingHasAlreadyOccurred) {
                    _scrollingHasAlreadyOccurred = true;
                    sAnalytics.swipeHistoryListOnCryptoFavouriteWalletScreen(
                      openedAsset: widget.currency.symbol,
                    );
                  }
                } else if (scrollNotification is ScrollEndNotification) {
                  _snapAppbar();
                }

                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
                    sliver: SliverToBoxAdapter(
                      child: WalletPriceSection(currency: widget.currency),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: WalletActionsRow(currency: widget.currency),
                  ),
                  SliverToBoxAdapter(
                    child: WalletEarnSection(currency: widget.currency),
                  ),
                  SliverToBoxAdapter(
                    child: SBasicHeader(
                      title: intl.wallet_transactions,
                      buttonTitle: intl.wallet_history_view_all,
                      showLinkButton: showViewAllBoatonOnHistory,
                      onTap: () {
                        sRouter.push(
                          AssetTransactionHistoryRouter(assetId: widget.currency.symbol),
                        );
                      },
                    ),
                  ),
                  TransactionsList(
                    scrollController: _scrollController,
                    symbol: widget.currency.symbol,
                    onItemTapLisener: (symbol) {
                      sAnalytics.tapOnTheButtonAnyHistoryTrxOnCryptoFavouriteWalletScreen(
                        openedAsset: symbol,
                      );
                    },
                    onData: (items) {
                      if (items.length >= 5) {
                        setState(() {
                          showViewAllBoatonOnHistory = true;
                        });
                      }
                    },
                    source: TransactionItemSource.cryptoAccount,
                    mode: TransactionListMode.preview,
                  ),
                  const SliverToBoxAdapter(
                    child: SpaceH300(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
