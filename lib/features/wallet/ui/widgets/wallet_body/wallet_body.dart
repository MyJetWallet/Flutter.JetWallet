import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_header.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../../actions/action_send/widgets/send_options.dart';
import '../../../../actions/circle_actions/circle_actions.dart';
import '../../../../app/store/app_store.dart';

const _collapsedCardHeight = 200.0;
const _expandedCardHeight = 270.0;

class WalletBody extends StatefulObserverWidget {
  const WalletBody({
    super.key,
    required this.currency,
    required this.pageController,
    required this.pageCount,
  });

  final CurrencyModel currency;
  final PageController pageController;
  final int pageCount;

  @override
  State<StatefulWidget> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  bool silverCollapsed = false;
  bool _scrollingHasAlreadyOccurred = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = sKit.colors;

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    return Material(
      color: colors.white,
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
        child: Stack(
          children: [
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 226,
                  collapsedHeight: 64,
                  pinned: true,
                  stretch: true,
                  backgroundColor: sKit.colors.white,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  leadingWidth: 48,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: SIconButton(
                      onTap: () => Navigator.pop(context),
                      defaultIcon: const SBackIcon(),
                      pressedIcon: const SBackPressedIcon(),
                    ),
                  ),
                  title: Column(
                    children: [
                      if (silverCollapsed) const SizedBox(height: 10),
                      if (!silverCollapsed)
                        Text(
                          widget.currency.description,
                          style: sTextH5Style.copyWith(
                            color: sKit.colors.black,
                          ),
                        ),
                      Text(
                        intl.wallet_simple_account,
                        style: sBodyText2Style.copyWith(
                          color: sKit.colors.grey1,
                        ),
                      ),
                    ],
                  ),
                  flexibleSpace: WalletHeader(
                    curr: widget.currency,
                    pageController: widget.pageController,
                    pageCount: widget.pageCount,
                  ),
                ),
                if (widget.currency.supportsAtLeastOneBuyMethod ||
                    widget.currency.supportsCryptoDeposit ||
                    widget.currency.isAssetBalanceNotEmpty ||
                    (widget.currency.isAssetBalanceNotEmpty && widget.currency.supportsAtLeastOneWithdrawalMethod))
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 24,
                        bottom: 28,
                      ),
                      child: CircleActionButtons(
                        showBuy: widget.currency.supportsAtLeastOneBuyMethod,
                        showReceive: widget.currency.supportsCryptoDeposit,
                        showExchange: widget.currency.isAssetBalanceNotEmpty,
                        showSend: widget.currency.isAssetBalanceNotEmpty &&
                            widget.currency.supportsAtLeastOneWithdrawalMethod,
                        onBuy: () {
                          sAnalytics.newBuyTapBuy(
                            source: 'My Assets - Asset -  Buy',
                          );
                          final actualAsset = widget.currency;

                          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => showPayWithBottomSheet(
                                context: context,
                                currency: actualAsset,
                              ),
                              from: BlockingType.deposit,
                            );
                          } else {
                            kycAlertHandler.handle(
                              status: kycState.depositStatus,
                              isProgress: kycState.verificationInProgress,
                              navigatePop: true,
                              currentNavigate: () {
                                showSendTimerAlertOr(
                                  context: context,
                                  or: () => showPayWithBottomSheet(
                                    context: context,
                                    currency: actualAsset,
                                  ),
                                  from: BlockingType.deposit,
                                );
                              },
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications: kycState.requiredVerifications,
                            );
                          }
                        },
                        onReceive: () {
                          if (widget.currency.type == AssetType.crypto) {
                            final actualAsset = widget.currency;
                            if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
                              showSendTimerAlertOr(
                                context: context,
                                or: () => sRouter.navigate(
                                  CryptoDepositRouter(
                                    header: intl.balanceActionButtons_receive,
                                    currency: actualAsset,
                                  ),
                                ),
                                from: BlockingType.deposit,
                              );
                            } else {
                              kycAlertHandler.handle(
                                status: kycState.depositStatus,
                                isProgress: kycState.verificationInProgress,
                                currentNavigate: () {
                                  showSendTimerAlertOr(
                                    context: context,
                                    or: () => sRouter.navigate(
                                      CryptoDepositRouter(
                                        header: intl.balanceActionButtons_receive,
                                        currency: actualAsset,
                                      ),
                                    ),
                                    from: BlockingType.deposit,
                                  );
                                },
                                requiredDocuments: kycState.requiredDocuments,
                                requiredVerifications: kycState.requiredVerifications,
                              );
                            }
                          } else {
                            sRouter.popUntilRoot();
                            getIt<AppStore>().setHomeTab(2);
                            if (getIt<AppStore>().tabsRouter != null) {
                              getIt<AppStore>().tabsRouter!.setActiveIndex(2);

                              if (getIt<IbanStore>().ibanTabController != null) {
                                getIt<IbanStore>().ibanTabController!.animateTo(0);
                              }
                            }
                          }
                        },
                        onSend: () {
                          sAnalytics.tabOnTheSendButton(
                            source: 'My Assets - Asset - Send',
                          );
                          final actualAsset = widget.currency;
                          if (kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed)) {
                            showSendOptions(
                              context,
                              actualAsset,
                              navigateBack: false,
                            );
                          } else {
                            kycAlertHandler.handle(
                              status: kycState.withdrawalStatus,
                              isProgress: kycState.verificationInProgress,
                              currentNavigate: () {
                                showSendOptions(context, actualAsset);
                              },
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications: kycState.requiredVerifications,
                            );
                          }
                        },
                        onExchange: () {
                          final actualAsset = widget.currency;
                          if (kycState.sellStatus == kycOperationStatus(KycStatus.allowed)) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => sRouter.push(
                                ConvertRouter(
                                  fromCurrency: actualAsset,
                                ),
                              ),
                              from: BlockingType.trade,
                            );
                          } else {
                            kycAlertHandler.handle(
                              status: kycState.sellStatus,
                              isProgress: kycState.verificationInProgress,
                              currentNavigate: () => showSendTimerAlertOr(
                                context: context,
                                or: () => sRouter.push(
                                  ConvertRouter(
                                    fromCurrency: actualAsset,
                                  ),
                                ),
                                from: BlockingType.trade,
                              ),
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications: kycState.requiredVerifications,
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
                const SliverToBoxAdapter(
                  child: SpaceH120(),
                ),
              ],
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
