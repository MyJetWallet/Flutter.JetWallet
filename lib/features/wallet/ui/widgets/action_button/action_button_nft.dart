import 'dart:async';

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
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/is_buy_with_currency_available_for.dart';
import 'package:jetwallet/utils/helpers/localized_action_items.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

import '../../../../../core/services/remote_config/remote_config_values.dart';
import '../../../../../core/services/user_info/user_info_service.dart';
import '../../../../../utils/constants.dart';
import '../../../../actions/action_deposit/widgets/deposit_options.dart';
import '../../../../nft/nft_details/store/nft_detail_store.dart';
import '../../../../nft/nft_details/ui/components/nft_terms_alert.dart';

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

class ActionButtonNft extends StatelessWidget {
  const ActionButtonNft({
    super.key,
    required this.transitionAnimationController,
    required this.nft,
  });

  final AnimationController transitionAnimationController;
  final NftMarket nft;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTDetailStore>(
      create: (context) => NFTDetailStore()..init(nft.symbol ?? ''),
      builder: (context, child) => _ActionButtonNft(
        nft: nft,
        transitionAnimationController: transitionAnimationController,
      ),
    );
  }
}

class _ActionButtonNft extends StatefulObserverWidget {
  const _ActionButtonNft({
    super.key,
    required this.transitionAnimationController,
    required this.nft,
  });

  final AnimationController transitionAnimationController;
  final NftMarket nft;

  @override
  State<_ActionButtonNft> createState() => _ActionButtonNftState();
}

class _ActionButtonNftState extends State<_ActionButtonNft> {
  bool actionActive = true;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;

    final store = NFTDetailStore.of(context);

    void updateActionState() {
      setState(() {
        actionActive = !actionActive;
      });

      getIt.get<AppStore>().setActionMenuActive(
            !getIt.get<AppStore>().actionMenuActive,
          );
    }

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

    void sellNFT() {
      updateActionState();
      Navigator.pop(context);

      sRouter.navigate(
        NFTSellRouter(
          nft: widget.nft,
        ),
      );
    }

    void sendNFT() {
      updateActionState();
      Navigator.pop(context);

      sRouter.push(
        WithdrawRouter(
          withdrawal: WithdrawalModel(
            nft: widget.nft,
          ),
        ),
      );
    }

    final kyc = getIt.get<KycService>();
    final handler = getIt.get<KycAlertHandler>();

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
                            isBuyFromCardAvailable: false,
                            actionItemLocalized: localizedActionItems(context),
                            isNotEmptyBalance: true,
                            isDepositAvailable: false,
                            isWithdrawAvailable: true,
                            isSendAvailable: true,
                            isReceiveAvailable: false,
                            isConvertAvailable: false,
                            onBuy: () {},
                            onBuyFromCard: () {},
                            onSell: () async {
                              if (store.canCLick) {
                                store.toggleClick(false);

                                Timer(
                                  const Duration(
                                    seconds: 2,
                                  ),
                                  () => store.toggleClick(true),
                                );
                              } else {
                                return;
                              }
                              void sellClicked() {
                                if (kyc.depositStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.withdrawalStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.sellStatus ==
                                        kycOperationStatus(KycStatus.allowed)) {
                                  showSendTimerAlertOr(
                                    context: context,
                                    or: () => sellNFT(),
                                  );
                                } else {
                                  handler.handle(
                                    status: kyc.depositStatus !=
                                            kycOperationStatus(
                                                KycStatus.allowed)
                                        ? kyc.depositStatus
                                        : kyc.withdrawalStatus !=
                                                kycOperationStatus(
                                                    KycStatus.allowed)
                                            ? kyc.withdrawalStatus
                                            : kyc.sellStatus,
                                    isProgress: kyc.verificationInProgress,
                                    currentNavigate: () => showSendTimerAlertOr(
                                      context: context,
                                      or: () => sellNFT(),
                                    ),
                                    requiredDocuments: kyc.requiredDocuments,
                                    requiredVerifications:
                                        kyc.requiredVerifications,
                                  );
                                }
                              }

                              final userInfo =
                                  getIt.get<UserInfoService>().userInfo;

                              if (userInfo.hasNftDisclaimers) {
                                await store.initNftDisclaimer();
                                if (store.send) {
                                  sellClicked();
                                } else {
                                  sShowNftTermsAlertPopup(
                                    context,
                                    store as NFTDetailStore,
                                    willPopScope: false,
                                    image: Image.asset(
                                      disclaimerAsset,
                                      width: 80,
                                      height: 80,
                                    ),
                                    primaryText: intl.nft_disclaimer_title,
                                    secondaryText:
                                        intl.nft_disclaimer_firstText,
                                    secondaryText2: intl.nft_disclaimer_terms,
                                    secondaryText3:
                                        intl.nft_disclaimer_secondText,
                                    primaryButtonName: intl.earn_terms_continue,
                                    onPrivacyPolicyTap: () {
                                      sRouter.navigate(
                                        HelpCenterWebViewRouter(
                                          link: nftTermsLink,
                                        ),
                                      );
                                    },
                                    onPrimaryButtonTap: () {
                                      store.sendAnswers(
                                        () {
                                          Navigator.pop(context);
                                          sellClicked();
                                        },
                                      );
                                    },
                                    child: const SizedBox(),
                                  );
                                }
                              } else {
                                sellClicked();
                              }
                            },
                            onConvert: () {},
                            onDeposit: () {},
                            onWithdraw: () {},
                            onSend: () async {
                              if (store.canCLick) {
                                store.toggleClick(false);

                                Timer(
                                  const Duration(
                                    seconds: 2,
                                  ),
                                  () => store.toggleClick(true),
                                );
                              } else {
                                return;
                              }
                              void sendClicked() {
                                if (kyc.depositStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.withdrawalStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.sellStatus ==
                                        kycOperationStatus(KycStatus.allowed)) {
                                  showSendTimerAlertOr(
                                    context: context,
                                    or: () => sendNFT(),
                                  );
                                } else {
                                  handler.handle(
                                    status: kyc.depositStatus !=
                                            kycOperationStatus(
                                                KycStatus.allowed)
                                        ? kyc.depositStatus
                                        : kyc.withdrawalStatus !=
                                                kycOperationStatus(
                                                    KycStatus.allowed)
                                            ? kyc.withdrawalStatus
                                            : kyc.sellStatus,
                                    isProgress: kyc.verificationInProgress,
                                    currentNavigate: () => showSendTimerAlertOr(
                                      context: context,
                                      or: () => sendNFT(),
                                    ),
                                    requiredDocuments: kyc.requiredDocuments,
                                    requiredVerifications:
                                        kyc.requiredVerifications,
                                  );
                                }
                              }

                              final userInfo =
                                  getIt.get<UserInfoService>().userInfo;

                              if (userInfo.hasNftDisclaimers) {
                                await store.initNftDisclaimer();
                                if (store.send) {
                                  sendClicked();
                                } else {
                                  sShowNftTermsAlertPopup(
                                    context,
                                    store as NFTDetailStore,
                                    willPopScope: false,
                                    image: Image.asset(
                                      disclaimerAsset,
                                      width: 80,
                                      height: 80,
                                    ),
                                    primaryText: intl.nft_disclaimer_title,
                                    secondaryText:
                                        intl.nft_disclaimer_firstText,
                                    secondaryText2: intl.nft_disclaimer_terms,
                                    secondaryText3:
                                        intl.nft_disclaimer_secondText,
                                    primaryButtonName: intl.earn_terms_continue,
                                    onPrivacyPolicyTap: () {
                                      sRouter.navigate(
                                        HelpCenterWebViewRouter(
                                          link: nftTermsLink,
                                        ),
                                      );
                                    },
                                    onPrimaryButtonTap: () {
                                      store.sendAnswers(
                                        () {
                                          Navigator.pop(context);
                                          sendClicked();
                                        },
                                      );
                                    },
                                    child: const SizedBox(),
                                  );
                                }
                              } else {
                                sendClicked();
                              }
                            },
                            onReceive: () {},
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
                            isBuyFromCardAvailable: false,
                            actionItemLocalized: localizedActionItems(context),
                            isNotEmptyBalance: true,
                            isDepositAvailable: false,
                            isWithdrawAvailable: true,
                            isSendAvailable: true,
                            isReceiveAvailable: false,
                            isConvertAvailable: false,
                            onBuy: () {},
                            onBuyFromCard: () {},
                            onSell: () async {
                              if (store.canCLick) {
                                store.toggleClick(false);

                                Timer(
                                  const Duration(
                                    seconds: 2,
                                  ),
                                  () => store.toggleClick(true),
                                );
                              } else {
                                return;
                              }
                              void sellClicked() {
                                if (kyc.depositStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.withdrawalStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.sellStatus ==
                                        kycOperationStatus(KycStatus.allowed)) {
                                  showSendTimerAlertOr(
                                    context: context,
                                    or: () => sellNFT(),
                                  );
                                } else {
                                  handler.handle(
                                    status: kyc.depositStatus !=
                                            kycOperationStatus(
                                                KycStatus.allowed)
                                        ? kyc.depositStatus
                                        : kyc.withdrawalStatus !=
                                                kycOperationStatus(
                                                    KycStatus.allowed)
                                            ? kyc.withdrawalStatus
                                            : kyc.sellStatus,
                                    isProgress: kyc.verificationInProgress,
                                    currentNavigate: () => showSendTimerAlertOr(
                                      context: context,
                                      or: () => sellNFT(),
                                    ),
                                    requiredDocuments: kyc.requiredDocuments,
                                    requiredVerifications:
                                        kyc.requiredVerifications,
                                  );
                                }
                              }

                              final userInfo =
                                  getIt.get<UserInfoService>().userInfo;

                              if (userInfo.hasNftDisclaimers) {
                                await store.initNftDisclaimer();
                                if (store.send) {
                                  sellClicked();
                                } else {
                                  sShowNftTermsAlertPopup(
                                    context,
                                    store as NFTDetailStore,
                                    willPopScope: false,
                                    image: Image.asset(
                                      disclaimerAsset,
                                      width: 80,
                                      height: 80,
                                    ),
                                    primaryText: intl.nft_disclaimer_title,
                                    secondaryText:
                                        intl.nft_disclaimer_firstText,
                                    secondaryText2: intl.nft_disclaimer_terms,
                                    secondaryText3:
                                        intl.nft_disclaimer_secondText,
                                    primaryButtonName: intl.earn_terms_continue,
                                    onPrivacyPolicyTap: () {
                                      sRouter.navigate(
                                        HelpCenterWebViewRouter(
                                          link: nftTermsLink,
                                        ),
                                      );
                                    },
                                    onPrimaryButtonTap: () {
                                      store.sendAnswers(
                                        () {
                                          Navigator.pop(context);
                                          sellClicked();
                                        },
                                      );
                                    },
                                    child: const SizedBox(),
                                  );
                                }
                              } else {
                                sellClicked();
                              }
                            },
                            onConvert: () {},
                            onDeposit: () {},
                            onWithdraw: () {},
                            onSend: () async {
                              if (store.canCLick) {
                                store.toggleClick(false);

                                Timer(
                                  const Duration(
                                    seconds: 2,
                                  ),
                                  () => store.toggleClick(true),
                                );
                              } else {
                                return;
                              }

                              void sendClicked() {
                                if (kyc.depositStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.withdrawalStatus ==
                                        kycOperationStatus(KycStatus.allowed) &&
                                    kyc.sellStatus ==
                                        kycOperationStatus(KycStatus.allowed)) {
                                  showSendTimerAlertOr(
                                    context: context,
                                    or: () => sendNFT(),
                                  );
                                } else {
                                  handler.handle(
                                    status: kyc.depositStatus !=
                                            kycOperationStatus(
                                                KycStatus.allowed)
                                        ? kyc.depositStatus
                                        : kyc.withdrawalStatus !=
                                                kycOperationStatus(
                                                    KycStatus.allowed)
                                            ? kyc.withdrawalStatus
                                            : kyc.sellStatus,
                                    isProgress: kyc.verificationInProgress,
                                    currentNavigate: () => showSendTimerAlertOr(
                                      context: context,
                                      or: () => sendNFT(),
                                    ),
                                    requiredDocuments: kyc.requiredDocuments,
                                    requiredVerifications:
                                        kyc.requiredVerifications,
                                  );
                                }
                              }

                              final userInfo =
                                  getIt.get<UserInfoService>().userInfo;

                              if (userInfo.hasNftDisclaimers) {
                                await store.initNftDisclaimer();
                                if (store.send) {
                                  sendClicked();
                                } else {
                                  sShowNftTermsAlertPopup(
                                    context,
                                    store as NFTDetailStore,
                                    willPopScope: false,
                                    image: Image.asset(
                                      disclaimerAsset,
                                      width: 80,
                                      height: 80,
                                    ),
                                    primaryText: intl.nft_disclaimer_title,
                                    secondaryText:
                                        intl.nft_disclaimer_firstText,
                                    secondaryText2: intl.nft_disclaimer_terms,
                                    secondaryText3:
                                        intl.nft_disclaimer_secondText,
                                    primaryButtonName: intl.earn_terms_continue,
                                    onPrivacyPolicyTap: () {
                                      sRouter.navigate(
                                        HelpCenterWebViewRouter(
                                          link: nftTermsLink,
                                        ),
                                      );
                                    },
                                    onPrimaryButtonTap: () {
                                      store.sendAnswers(
                                        () {
                                          Navigator.pop(context);
                                          sendClicked();
                                        },
                                      );
                                    },
                                    child: const SizedBox(),
                                  );
                                }
                              } else {
                                sendClicked();
                              }
                            },
                            onReceive: () {},
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
