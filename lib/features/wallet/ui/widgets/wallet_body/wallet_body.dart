import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/ui/widgets/fade_on_scroll.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/card_block/wallet_card.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/card_block/wallet_card_collapsed.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../../actions/action_send/widgets/send_options.dart';
import '../../../../actions/circle_actions/circle_actions.dart';
import '../../../../app/store/app_store.dart';

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

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    const walletBackground = walletGreenBackgroundImageAsset;

    return Material(
      color: colors.white,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _snapAppbar();

          return false;
        },
        child: Stack(
          children: [
            CustomScrollView(
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
                            title: intl.portfolioHeader_balance,
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
                const SliverToBoxAdapter(
                  child: SpaceH120(),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Material(
                color: colors.white,
                child: SizedBox(
                  height: 127,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SDivider(),
                      const SpaceH16(),
                      CircleActionButtons(
                        showBuy: widget.currency.supportsAtLeastOneBuyMethod,
                        showReceive: widget.currency.supportsCryptoDeposit,
                        showExchange: widget.currency.isAssetBalanceNotEmpty,
                        showSend: widget.currency.isAssetBalanceNotEmpty &&
                            widget.currency.supportsCryptoWithdrawal,
                        onBuy: () {
                          sAnalytics.newBuyTapBuy(
                            source: 'My Assets - Asset -  Buy',
                          );
                          final actualAsset = widget.currency;
                          if (kycState.depositStatus ==
                              kycOperationStatus(KycStatus.allowed)) {
                            showSendTimerAlertOr(
                              context: context,
                              or: () => sRouter.push(
                                PaymentMethodRouter(currency: actualAsset),
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
                                  or: () => sRouter.push(
                                    PaymentMethodRouter(currency: actualAsset),
                                  ),
                                  from: BlockingType.deposit,
                                );
                              },
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications:
                                  kycState.requiredVerifications,
                            );
                          }
                        },
                        onReceive: () {
                          if (widget.currency.type == AssetType.crypto) {
                            final actualAsset = widget.currency;
                            if (kycState.depositStatus ==
                                kycOperationStatus(KycStatus.allowed)) {
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
                                        header:
                                            intl.balanceActionButtons_receive,
                                        currency: actualAsset,
                                      ),
                                    ),
                                    from: BlockingType.deposit,
                                  );
                                },
                                requiredDocuments: kycState.requiredDocuments,
                                requiredVerifications:
                                    kycState.requiredVerifications,
                              );
                            }
                          } else {
                            sRouter.popUntilRoot();
                            getIt<AppStore>().setHomeTab(2);
                            if (getIt<AppStore>().tabsRouter != null) {
                              getIt<AppStore>().tabsRouter!.setActiveIndex(2);
                            }
                          }
                        },
                        onSend: () {
                          final actualAsset = widget.currency;
                          if (kycState.sellStatus ==
                              kycOperationStatus(KycStatus.allowed)) {
                            showSendOptions(
                              context,
                              actualAsset,
                              navigateBack: false,
                            );
                          } else {
                            kycAlertHandler.handle(
                              status: kycState.sellStatus,
                              isProgress: kycState.verificationInProgress,
                              currentNavigate: () {
                                showSendOptions(context, actualAsset);
                              },
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications:
                                  kycState.requiredVerifications,
                            );
                          }
                        },
                        onExchange: () {
                          final actualAsset = widget.currency;
                          if (kycState.sellStatus ==
                              kycOperationStatus(KycStatus.allowed)) {
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
                              navigatePop: false,
                              requiredDocuments: kycState.requiredDocuments,
                              requiredVerifications:
                                  kycState.requiredVerifications,
                            );
                          }
                        },
                      ),
                      const SpaceH34(),
                    ],
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
