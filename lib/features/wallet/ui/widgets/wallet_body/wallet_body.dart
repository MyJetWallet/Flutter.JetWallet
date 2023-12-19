import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../../actions/action_send/widgets/send_options.dart';
import '../../../../actions/circle_actions/circle_actions.dart';

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

    final kycState = getIt.get<KycService>();
    final handler = getIt.get<KycAlertHandler>();

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
                ? volumeFormat(
                    decimal: sSignalRModules.totalEurWalletBalance,
                    accuracy: widget.currency.accuracy,
                    symbol: widget.currency.symbol,
                  )
                : widget.currency.volumeBaseBalance(
                    getIt.get<FormatService>().baseCurrency,
                  ),
            mainSubtitle: getIt.get<FormatService>().baseCurrency.symbol != widget.currency.symbol
                ? widget.currency.symbol == 'EUR'
                    ? widget.currency.volumeBaseBalance(getIt.get<FormatService>().baseCurrency)
                    : widget.currency.volumeAssetBalance
                : null,
            mainHeaderTitle: widget.currency.description,
            mainHeaderSubtitle: intl.eur_wallet,
            mainHeaderCollapsedTitle: widget.currency.symbol == 'EUR'
                ? volumeFormat(
                    decimal: sSignalRModules.totalEurWalletBalance,
                    accuracy: widget.currency.accuracy,
                    symbol: widget.currency.symbol,
                  )
                : widget.currency.volumeBaseBalance(getIt.get<FormatService>().baseCurrency),
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: CircleActionButtons(
                        isSendDisabled: widget.currency.isAssetBalanceEmpty,
                        isSellDisabled: widget.currency.isAssetBalanceEmpty,
                        isConvertDisabled: widget.currency.isAssetBalanceEmpty,
                        onBuy: () {
                          sAnalytics.tapOnTheBuyWalletButton(
                            source: 'Wallets - Wallet - Buy',
                          );

                          final actualAsset = widget.currency;

                          final isCardsAvailable =
                              actualAsset.buyMethods.any((element) => element.id == PaymentMethodType.bankCard);

                          final isSimpleAccountAvaible = sSignalRModules.paymentProducts
                                  ?.any((element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount) ??
                              false;

                          final isBankingAccountsAvaible = sSignalRModules.paymentProducts
                                  ?.any((element) => element.id == AssetPaymentProductsEnum.bankingIbanAccount) ??
                              false;

                          final isBuyAvaible = isCardsAvailable || isSimpleAccountAvaible || isBankingAccountsAvaible;

                          final isDepositBlocker = sSignalRModules.clientDetail.clientBlockers
                              .any((element) => element.blockingType == BlockingType.deposit);

                          if (kycState.tradeStatus == kycOperationStatus(KycStatus.blocked) || !isBuyAvaible) {
                            sNotification.showError(
                              intl.operation_bloked_text,
                              id: 1,
                            );
                            sAnalytics.errorBuyIsUnavailable();
                          } else if ((kycState.depositStatus == kycOperationStatus(KycStatus.blocked)) &&
                              !(sSignalRModules.bankingProfileData?.isAvaibleAnyAccount ?? false)) {
                            sNotification.showError(
                              intl.operation_bloked_text,
                              id: 1,
                            );
                            sAnalytics.errorBuyIsUnavailable();
                          } else if (isDepositBlocker &&
                              !(sSignalRModules.bankingProfileData?.isAvaibleAnyAccount ?? false)) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => showPayWithBottomSheet(
                                context: context,
                                currency: actualAsset,
                              ),
                              from: [BlockingType.deposit],
                            );
                          } else if (isBuyAvaible) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => showPayWithBottomSheet(
                                context: context,
                                currency: actualAsset,
                              ),
                              from: [BlockingType.trade],
                            );
                          } else {
                            handler.handle(
                              status: kycState.tradeStatus,
                              isProgress: kycState.verificationInProgress,
                              currentNavigate: () => showPayWithBottomSheet(
                                context: context,
                                currency: actualAsset,
                              ),
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications: kycState.requiredVerifications,
                            );
                          }
                        },
                        onSell: () {
                          sAnalytics.tapOnTheSellButton(
                            source: 'Wallet - Buy',
                          );

                          final actualAsset = widget.currency;

                          if (kycState.tradeStatus == kycOperationStatus(KycStatus.allowed)) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => sRouter.push(
                                AmountRoute(
                                  tab: AmountScreenTab.sell,
                                  asset: actualAsset,
                                ),
                              ),
                              from: [BlockingType.trade],
                            );
                          } else {
                            sNotification.showError(
                              intl.operation_bloked_text,
                              id: 1,
                            );
                          }
                        },
                        onReceive: () {
                          final actualAsset = widget.currency;
                          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed) &&
                              widget.currency.supportsCryptoDeposit) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => sRouter.navigate(
                                CryptoDepositRouter(
                                  header: intl.balanceActionButtons_receive,
                                  currency: actualAsset,
                                ),
                              ),
                              from: [BlockingType.deposit],
                            );
                          } else if (!widget.currency.supportsCryptoDeposit) {
                            sNotification.showError(
                              intl.operation_bloked_text,
                              id: 1,
                            );
                          } else {
                            handler.handle(
                              status: kycState.depositStatus,
                              isProgress: kycState.verificationInProgress,
                              currentNavigate: () => sRouter.navigate(
                                CryptoDepositRouter(
                                  header: intl.balanceActionButtons_receive,
                                  currency: actualAsset,
                                ),
                              ),
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications: kycState.requiredVerifications,
                            );
                          }
                        },
                        onSend: () {
                          sAnalytics.tabOnTheSendButton(
                            source: 'My Assets - Asset - Send',
                          );

                          final actualAsset = widget.currency;
                          showSendOptions(
                            context,
                            actualAsset,
                            navigateBack: false,
                          );
                        },
                        onConvert: () {
                          sAnalytics.tapOnTheConvertButton(
                            source: 'Wallet - Convert',
                          );
                          final actualAsset = widget.currency;
                          if (kycState.tradeStatus == kycOperationStatus(KycStatus.allowed)) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => sRouter.push(
                                AmountRoute(
                                  tab: AmountScreenTab.convert,
                                  asset: actualAsset,
                                ),
                              ),
                              from: [BlockingType.trade],
                            );
                          } else {
                            sNotification.showError(
                              intl.operation_bloked_text,
                              id: 1,
                            );
                          }
                        },
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
                  TransactionsList(
                    scrollController: _scrollController,
                    symbol: widget.currency.symbol,
                    onItemTapLisener: (symbol) {
                      sAnalytics.tapOnTheButtonAnyHistoryTrxOnCryptoFavouriteWalletScreen(
                        openedAsset: symbol,
                      );
                    },
                  ),
                  /*
                  if (widget.currency.isAssetBalanceNotEmpty) ...[
                    TransactionsList(
                      scrollController: _scrollController,
                      symbol: widget.currency.symbol,
                      onItemTapLisener: (symbol) {
                        sAnalytics.tapOnTheButtonAnyHistoryTrxOnCryptoFavouriteWalletScreen(
                          openedAsset: symbol,
                        );
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
                  */
                  const SliverToBoxAdapter(
                    child: SpaceH120(),
                  ),
                ],
              ),
            ),
          ),
        ],
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
