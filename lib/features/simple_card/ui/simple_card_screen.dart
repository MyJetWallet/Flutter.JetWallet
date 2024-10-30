import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_store.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_settings.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_widget.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/show_simple_card_deposit_by_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/show_simple_card_withdraw_to_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/simple_card_circle_actions.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/wallet_button.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sevsitive_response.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/router/app_router.dart';
import '../../../utils/models/currency_model.dart';
import '../../app/store/app_store.dart';

const _collapsedCardHeight = 200.0;
const _expandedCardHeight = 270.0;

@RoutePage(name: 'SimpleCardRouter')
class SimpleCardScreen extends StatefulObserverWidget {
  const SimpleCardScreen({
    super.key,
    required this.isAddCashAvailable,
  });

  final bool isAddCashAvailable;

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

    final simpleCardStore = getIt.get<SimpleCardStore>();

    final kycState = getIt.get<KycService>();
    final handler = getIt.get<KycAlertHandler>();

    final eurCurrency = sSignalRModules.currenciesList.firstWhere(
      (asset) => asset.symbol == 'EUR',
      orElse: () => CurrencyModel.empty(),
    );

    return VisibilityDetector(
      key: const Key('earn-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          sAnalytics.viewVirtualCardScreen(
            cardID: simpleCardStore.cardFull?.cardId ?? '',
          );
        }
      },
      child: SPageFrame(
        loaderText: intl.loader_please_wait,
        loading: simpleCardStore.loader,
        header: GlobalBasicAppBar(
          title: simpleCardStore.cardFull?.label ?? 'Simple card',
          subtitle: intl.simple_card_type_virtual,
          hasRightIcon: false,
          onLeftIconTap: () {
            sAnalytics.tapBackFromVirualCard(
              cardID: simpleCardStore.cardFull?.cardId ?? '',
            );
            Navigator.pop(context);
          },
        ),
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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: CardWidget(
                  card: simpleCardStore.cardFull ?? const CardDataModel(),
                  cardSensitive: simpleCardStore.cardSensitiveData ?? SimpleCardSensitiveResponse(),
                  isFrozen: simpleCardStore.isFrozen,
                  showDetails: simpleCardStore.showDetails,
                  onTap: () {
                    if (simpleCardStore.showDetails) {
                      sAnalytics.tapHideCard(
                        cardID: simpleCardStore.cardFull?.cardId ?? '',
                      );
                    } else {
                      sAnalytics.tapShowCard(
                        cardID: simpleCardStore.cardFull?.cardId ?? '',
                      );
                    }
                    simpleCardStore.setShowDetails(!simpleCardStore.showDetails);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 8,
                    bottom: 4,
                  ),
                  child: Center(
                    child: Text(
                      getIt<AppStore>().isBalanceHide
                          ? '**** ${eurCurrency.symbol}'
                          : (simpleCardStore.cardFull?.balance ?? Decimal.zero).toFormatSum(
                              accuracy: eurCurrency.accuracy,
                              symbol: eurCurrency.symbol,
                            ),
                      style: STStyles.header3,
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
                    isTerminateAvailable: simpleCardStore.isFrozen,
                    isAddCashAvailable: widget.isAddCashAvailable,
                    onAddCash: () {
                      sAnalytics.tapOnTheDepositButton(
                        source: 'V.Card - Deposit',
                      );
                      handler.handle(
                        multiStatus: [
                          kycState.depositStatus,
                        ],
                        isProgress: kycState.verificationInProgress,
                        currentNavigate: () => showSimpleCardDepositBySelector(
                          context: context,
                          onClose: () {},
                          card: simpleCardStore.cardFull ?? const CardDataModel(),
                        ),
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    },
                    isWithdrawAvailable: simpleCardStore.cardFull?.isNotEmptyBalance ?? false,
                    onShowDetails: () {
                      simpleCardStore.setShowDetails(!simpleCardStore.showDetails);
                    },
                    onFreeze: () {
                      if (simpleCardStore.isFrozen) {
                        sAnalytics.tapOnUnfreeze(
                          cardID: simpleCardStore.cardFull?.cardId ?? '',
                        );
                      } else {
                        sAnalytics.tapFreezeCard(
                          cardID: simpleCardStore.cardFull?.cardId ?? '',
                        );
                      }
                      simpleCardStore.setFrozen(!simpleCardStore.isFrozen);
                    },
                    onSettings: () {
                      sAnalytics.tapOnSettings(
                        cardID: simpleCardStore.cardFull?.cardId ?? '',
                      );
                      sAnalytics.viewCardSettings(
                        cardID: simpleCardStore.cardFull?.cardId ?? '',
                      );
                      showCardSettings(
                        context: context,
                        onChangeLableTap: () {
                          final catdId = simpleCardStore.cardFull?.cardId ?? '';
                          sAnalytics.tapOnTheEditVirtualCardLabelButton(
                            cardID: catdId,
                          );
                          sAnalytics.editVirtualCardLabelScreenView(
                            cardID: catdId,
                          );
                          sRouter
                              .push(
                            SimpleCardLabelRouter(
                              initLabel: simpleCardStore.cardFull?.label ?? '',
                              accountId: catdId,
                            ),
                          )
                              .then((value) {
                            sRouter.maybePop();
                            if (value is String) {
                              try {
                                sAnalytics.tapOnTheSaveChangesFromEditVirtualCardLabelButton(
                                  cardID: catdId,
                                );
                                simpleCardStore.localUpdateCardLable(value);
                              } catch (e) {
                                log(e.toString());
                              }
                            } else {
                              sAnalytics.tapOnTheBackFromEditVirtualCardLabelButton(
                                cardID: catdId,
                              );
                            }
                          });
                        },
                        onFreezeTap: () {
                          if (simpleCardStore.isFrozen) {
                            sAnalytics.tapOnUnfreeze(
                              cardID: simpleCardStore.cardFull?.cardId ?? '',
                            );
                          } else {
                            sAnalytics.tapFreezeCard(
                              cardID: simpleCardStore.cardFull?.cardId ?? '',
                            );
                          }
                          simpleCardStore.setFrozen(!simpleCardStore.isFrozen);
                        },
                      );
                    },
                    onTerminate: () {
                      simpleCardStore.terminateCard();
                    },
                    onWithdraw: () {
                      handler.handle(
                        multiStatus: [
                          kycState.withdrawalStatus,
                        ],
                        isProgress: kycState.verificationInProgress,
                        currentNavigate: () => showSimpleCardWithdrawToSelector(
                          context: context,
                          onClose: () {},
                          card: simpleCardStore.cardFull ?? const CardDataModel(),
                        ),
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: WalletsButton(
                  cardNumber: simpleCardStore.cardSensitiveData?.cardNumber ?? '',
                  cardId: simpleCardStore.cardFull?.cardId ?? '',
                ),
              ),
              SliverToBoxAdapter(
                child: SPaddingH24(
                  child: Text(
                    intl.wallet_transactions,
                    style: STStyles.header5,
                  ),
                ),
              ),
              if (simpleCardStore.cardFull != null) ...[
                TransactionsList(
                  scrollController: _scrollController,
                  symbol: simpleCardStore.cardFull?.currency,
                  accountId: simpleCardStore.cardFull?.cardId,
                  onItemTapLisener: (symbol) {},
                  source: TransactionItemSource.simpleCard,
                  isSimpleCard: true,
                  onError: (String reason) {
                    sAnalytics.viewErrorOnCardScreen(
                      cardID: simpleCardStore.cardFull?.cardId ?? '',
                      reason: reason,
                    );
                  },
                ),
              ] else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          smileAsset,
                          width: 36,
                          height: 36,
                        ),
                        Text(
                          intl.wallet_simple_account_empty,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: STStyles.subtitle2.copyWith(
                            color: sKit.colors.grey2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(
                child: SpaceH300(),
              ),
            ],
          ),
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
