import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_alert_bottom_sheet.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/action_withdraw/widgets/withdraw_options.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/is_buy_with_currency_available_for.dart';
import 'package:jetwallet/utils/helpers/localized_action_items.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

import '../../../../actions/action_deposit/widgets/deposit_options.dart';

const _expandInterval = Interval(
  0.0,
  0.5,
  curve: Cubic(0.42, 0, 0, 0.99),
);

const _narrowInterval = Interval(
  0.5,
  1.0,
  curve: Cubic(1, 0, 0.58, 1),
);

class ActionButton extends StatefulObserverWidget {
  const ActionButton({
    Key? key,
    required this.transitionAnimationController,
    required this.currency,
  }) : super(key: key);

  final AnimationController transitionAnimationController;
  final CurrencyModel currency;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool actionActive = true;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final isDepositAvailable =
        widget.currency.supportsAtLeastOneFiatDepositMethod ||
            widget.currency.supportsCryptoDeposit;

    void updateActionState() {
      setState(() {
        actionActive = !actionActive;
      });
      getIt.get<AppStore>().setActionMenuActive(
            !getIt.get<AppStore>().actionMenuActive,
          );
    }

    final isBuyAvailable = isBuyWithCurrencyAvailableFor(
      widget.currency.symbol,
      currencies,
    );

    final scaleAnimation = Tween(
      begin: 0.0,
      end: 80.0,
    ).animate(
      CurvedAnimation(
        parent: widget.transitionAnimationController,
        curve: Curves.linear,
      ),
    );

    late Color currentNameColor;

    currentNameColor =
        highlighted ? colors.white.withOpacity(0.8) : colors.white;

    void _onBuy(bool fromCard) {
      if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
        sRouter.navigate(
          PaymentMethodRouter(currency: widget.currency),
        );
      } else {
        kycAlertHandler.handle(
          status: kycState.depositStatus,
          isProgress: kycState.verificationInProgress,
          currentNavigate: () => sRouter.navigate(
            PaymentMethodRouter(currency: widget.currency),
          ),
          requiredDocuments: kycState.requiredDocuments,
          requiredVerifications: kycState.requiredVerifications,
        );
      }
    }

    return Material(
      color: colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (scaleAnimation.value != 0) const SDivider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
              top: 23,
            ),
            child: AnimatedContainer(
              width: actionActive ? MediaQuery.of(context).size.width : 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: actionActive
                    ? BorderRadius.circular(16)
                    : BorderRadius.circular(100),
              ),
              duration: const Duration(milliseconds: 300),
              curve: actionActive
                  ? const Cubic(0.42, 0, 0, 0.99)
                  : const Cubic(1, 0, 0.58, 1),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: actionActive ? 1 : 0,
                    duration: Duration(milliseconds: actionActive ? 150 : 300),
                    curve: actionActive ? _expandInterval : _narrowInterval,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onHighlightChanged: (value) {
                        setState(() {
                          highlighted = value;
                        });
                      },
                      child: Center(
                        child: Text(
                          actionActive ? intl.actionButton_action : '',
                          style: sButtonTextStyle.copyWith(
                            color: currentNameColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (actionActive) {
                          sShowMenuActionSheet(
                            context: context,
                            isBuyAvailable: false,
                            isBuyFromCardAvailable:
                                widget.currency.supportsAtLeastOneBuyMethod,
                            actionItemLocalized: localizedActionItems(context),
                            isNotEmptyBalance:
                                widget.currency.isAssetBalanceNotEmpty,
                            isDepositAvailable: isDepositAvailable,
                            isWithdrawAvailable: widget
                                .currency.supportsAtLeastOneWithdrawalMethod,
                            isSendAvailable:
                                widget.currency.supportsCryptoWithdrawal,
                            isReceiveAvailable:
                                widget.currency.supportsCryptoDeposit,
                            isSellAvailable: false,
                            onBuy: () {
                              _onBuy(false);
                            },
                            onBuyFromCard: () {
                              _onBuy(true);
                            },
                            onSell: () {
                              if (kycState.sellStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                sRouter.navigate(
                                  CurrencySellRouter(
                                    currency: widget.currency,
                                  ),
                                );
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.sellStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () => sRouter.navigate(
                                    CurrencySellRouter(
                                      currency: widget.currency,
                                    ),
                                  ),
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onConvert: () {
                              if (kycState.sellStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                showSendTimerAlertOr(
                                  context: context,
                                  or: () {
                                    sRouter.push(
                                      ConvertRouter(
                                        fromCurrency: widget.currency,
                                      ),
                                    );
                                  },
                                  from: BlockingType.trade,
                                );
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.sellStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () => showSendTimerAlertOr(
                                    context: context,
                                    or: () {
                                      sRouter.push(
                                        ConvertRouter(
                                          fromCurrency: widget.currency,
                                        ),
                                      );
                                    },
                                    from: BlockingType.trade,
                                  ),
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onDeposit: () {
                              if (widget.currency.type == AssetType.fiat) {
                                if (kycState.depositStatus ==
                                    kycOperationStatus(
                                      KycStatus.allowed,
                                    )) {
                                  showDepositOptions(
                                    context,
                                    widget.currency,
                                  );
                                } else {
                                  kycAlertHandler.handle(
                                    status: kycState.depositStatus,
                                    isProgress: kycState.verificationInProgress,
                                    currentNavigate: () => showDepositOptions(
                                      context,
                                      widget.currency,
                                    ),
                                    requiredDocuments:
                                        kycState.requiredDocuments,
                                    requiredVerifications:
                                        kycState.requiredVerifications,
                                  );
                                }
                              } else {
                                if (kycState.depositStatus ==
                                    kycOperationStatus(
                                      KycStatus.allowed,
                                    )) {
                                  sRouter.navigate(
                                    CryptoDepositRouter(
                                      header: intl.actionButton_deposit,
                                      currency: widget.currency,
                                    ),
                                  );
                                } else {
                                  kycAlertHandler.handle(
                                    status: kycState.depositStatus,
                                    isProgress: kycState.verificationInProgress,
                                    currentNavigate: () {
                                      sRouter.navigate(
                                        CryptoDepositRouter(
                                          header: intl.actionButton_deposit,
                                          currency: widget.currency,
                                        ),
                                      );
                                    },
                                    requiredDocuments:
                                        kycState.requiredDocuments,
                                    requiredVerifications:
                                        kycState.requiredVerifications,
                                  );
                                }
                              }
                            },
                            onWithdraw: () {
                              if (kycState.withdrawalStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                showWithdrawOptions(
                                  context,
                                  widget.currency,
                                );
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.withdrawalStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () => showWithdrawOptions(
                                    context,
                                    widget.currency,
                                  ),
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onSend: () {
                              if (kycState.withdrawalStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                if (widget.currency.isAssetBalanceNotEmpty &&
                                    widget.currency.supportsCryptoWithdrawal) {
                                  showSendOptions(
                                    context,
                                    widget.currency,
                                  );
                                } else {
                                  sendAlertBottomSheet(context);
                                }
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.withdrawalStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () {
                                    if (widget
                                            .currency.isAssetBalanceNotEmpty &&
                                        widget.currency
                                            .supportsCryptoWithdrawal) {
                                      showSendOptions(
                                        context,
                                        widget.currency,
                                      );
                                    } else {
                                      sendAlertBottomSheet(context);
                                    }
                                    showSendOptions(
                                      context,
                                      widget.currency,
                                    );
                                  },
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onReceive: () {
                              if (kycState.depositStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                sRouter.navigate(
                                  CryptoDepositRouter(
                                    header: intl.actionButton_receive,
                                    currency: widget.currency,
                                  ),
                                );
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.depositStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () => sRouter.navigate(
                                    CryptoDepositRouter(
                                      header: intl.actionButton_receive,
                                      currency: widget.currency,
                                    ),
                                  ),
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onDissmis: updateActionState,
                            whenComplete: () {
                              if (!actionActive) updateActionState();
                            },
                            transitionAnimationController:
                                widget.transitionAnimationController,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                        updateActionState();
                      },
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: actionActive ? 0 : 1,
                    duration: Duration(milliseconds: actionActive ? 300 : 150),
                    curve: actionActive ? _expandInterval : _narrowInterval,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onHighlightChanged: (value) {
                        setState(() {
                          highlighted = value;
                        });
                      },
                      child: Center(
                        child: highlighted
                            ? const SActionActiveHighlightedIcon()
                            : const SActionActiveIcon(),
                      ),
                      onTap: () {
                        if (actionActive) {
                          sShowMenuActionSheet(
                            context: context,
                            isBuyAvailable: false,
                            isSellAvailable: false,
                            isBuyFromCardAvailable:
                                widget.currency.supportsAtLeastOneBuyMethod,
                            actionItemLocalized: localizedActionItems(context),
                            isNotEmptyBalance:
                                widget.currency.isAssetBalanceNotEmpty,
                            isDepositAvailable: isDepositAvailable,
                            isWithdrawAvailable: widget
                                .currency.supportsAtLeastOneWithdrawalMethod,
                            isSendAvailable:
                                widget.currency.supportsCryptoWithdrawal,
                            isReceiveAvailable:
                                widget.currency.supportsCryptoDeposit,
                            onBuy: () {
                              _onBuy(false);
                            },
                            onBuyFromCard: () {
                              _onBuy(true);
                            },
                            onSell: () {
                              if (kycState.sellStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                sRouter.navigate(
                                  CurrencySellRouter(
                                    currency: widget.currency,
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                                kycAlertHandler.handle(
                                  status: kycState.sellStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () {
                                    sRouter.navigate(
                                      CurrencySellRouter(
                                        currency: widget.currency,
                                      ),
                                    );
                                  },
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onConvert: () {
                              if (kycState.sellStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                showSendTimerAlertOr(
                                  context: context,
                                  or: () {
                                    sRouter.push(
                                      ConvertRouter(
                                        fromCurrency: widget.currency,
                                      ),
                                    );
                                  },
                                  from: BlockingType.trade,
                                );
                              } else {
                                Navigator.of(context).pop();
                                kycAlertHandler.handle(
                                  status: kycState.sellStatus,
                                  isProgress: kycState.verificationInProgress,
                                  navigatePop: true,
                                  currentNavigate: () => showSendTimerAlertOr(
                                    context: context,
                                    or: () {
                                      sRouter.push(
                                        ConvertRouter(
                                          fromCurrency: widget.currency,
                                        ),
                                      );
                                    },
                                    from: BlockingType.trade,
                                  ),
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onDeposit: () {
                              if (widget.currency.type == AssetType.fiat) {
                                if (kycState.depositStatus ==
                                    kycOperationStatus(
                                      KycStatus.allowed,
                                    )) {
                                  showDepositOptions(
                                    context,
                                    widget.currency,
                                  );
                                } else {
                                  kycAlertHandler.handle(
                                    status: kycState.depositStatus,
                                    isProgress: kycState.verificationInProgress,
                                    currentNavigate: () {
                                      showDepositOptions(
                                        context,
                                        widget.currency,
                                      );
                                    },
                                    requiredDocuments:
                                        kycState.requiredDocuments,
                                    requiredVerifications:
                                        kycState.requiredVerifications,
                                  );
                                }
                              } else {
                                if (kycState.depositStatus ==
                                    kycOperationStatus(
                                      KycStatus.allowed,
                                    )) {
                                  sRouter.navigate(
                                    CryptoDepositRouter(
                                      header: intl.actionButton_deposit,
                                      currency: widget.currency,
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  kycAlertHandler.handle(
                                    status: kycState.depositStatus,
                                    isProgress: kycState.verificationInProgress,
                                    currentNavigate: () {
                                      sRouter.navigate(
                                        CryptoDepositRouter(
                                          header: intl.actionButton_deposit,
                                          currency: widget.currency,
                                        ),
                                      );
                                    },
                                    requiredDocuments:
                                        kycState.requiredDocuments,
                                    requiredVerifications:
                                        kycState.requiredVerifications,
                                  );
                                }
                              }
                            },
                            onWithdraw: () {
                              if (kycState.withdrawalStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                showWithdrawOptions(
                                  context,
                                  widget.currency,
                                );
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.withdrawalStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () => showWithdrawOptions(
                                    context,
                                    widget.currency,
                                  ),
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onSend: () {
                              if (kycState.withdrawalStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                Navigator.pop(context);
                                if (widget.currency.isAssetBalanceNotEmpty &&
                                    widget.currency.supportsCryptoWithdrawal) {
                                  showSendTimerAlertOr(
                                    context: context,
                                    or: () {
                                      showSendOptions(
                                        context,
                                        widget.currency,
                                      );
                                    },
                                    from: BlockingType.withdrawal,
                                  );
                                } else {
                                  sendAlertBottomSheet(context);
                                }
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.withdrawalStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () {
                                    Navigator.pop(context);
                                    if (widget
                                            .currency.isAssetBalanceNotEmpty &&
                                        widget.currency
                                            .supportsCryptoWithdrawal) {
                                      showSendTimerAlertOr(
                                        context: context,
                                        or: () => showSendOptions(
                                          context,
                                          widget.currency,
                                        ),
                                        from: BlockingType.withdrawal,
                                      );
                                    } else {
                                      sendAlertBottomSheet(context);
                                    }
                                  },
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onReceive: () {
                              if (kycState.depositStatus ==
                                  kycOperationStatus(
                                    KycStatus.allowed,
                                  )) {
                                sRouter.navigate(
                                  CryptoDepositRouter(
                                    header: intl.actionButton_receive,
                                    currency: widget.currency,
                                  ),
                                );
                              } else {
                                kycAlertHandler.handle(
                                  status: kycState.depositStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () => sRouter.navigate(
                                    CryptoDepositRouter(
                                      header: intl.actionButton_receive,
                                      currency: widget.currency,
                                    ),
                                  ),
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                      kycState.requiredVerifications,
                                );
                              }
                            },
                            onDissmis: updateActionState,
                            whenComplete: () {
                              if (!actionActive) updateActionState();
                            },
                            transitionAnimationController:
                                widget.transitionAnimationController,
                          );
                        } else {
                          Navigator.pop(context);
                        }
                        updateActionState();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
