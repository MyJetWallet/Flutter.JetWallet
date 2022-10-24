import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
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
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

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

class ActionButtonNft extends StatefulWidget {
  const ActionButtonNft({
    super.key,
    required this.transitionAnimationController,
    required this.nft,
  });

  final AnimationController transitionAnimationController;
  final NftMarket nft;

  @override
  State<ActionButtonNft> createState() => _ActionButtonNftState();
}

class _ActionButtonNftState extends State<ActionButtonNft> {
  bool actionActive = true;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;

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
                            onSell: () {
                              updateActionState();

                              sRouter.navigate(
                                NFTSellRouter(
                                  nft: widget.nft,
                                ),
                              );
                            },
                            onConvert: () {},
                            onDeposit: () {},
                            onWithdraw: () {},
                            onSend: () {
                              updateActionState();

                              sRouter.navigate(
                                CurrencyWithdrawRouter(
                                  withdrawal: WithdrawalModel(
                                    nft: widget.nft,
                                  ),
                                ),
                              );
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
                            onSell: () {
                              updateActionState();

                              sRouter.navigate(
                                NFTSellRouter(
                                  nft: widget.nft,
                                ),
                              );
                            },
                            onConvert: () {},
                            onDeposit: () {},
                            onWithdraw: () {},
                            onSend: () {
                              updateActionState();

                              sRouter.navigate(
                                CurrencyWithdrawRouter(
                                  withdrawal: WithdrawalModel(
                                    nft: widget.nft,
                                  ),
                                ),
                              );
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
