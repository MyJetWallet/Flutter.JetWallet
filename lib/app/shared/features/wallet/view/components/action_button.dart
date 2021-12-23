import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../helpers/is_balance_empty.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../actions/action_buy/action_buy.dart';
import '../../../actions/action_deposit/action_deposit.dart';
import '../../../actions/action_receive/action_receive.dart';
import '../../../actions/action_sell/action_sell.dart';
import '../../../actions/action_send/action_send.dart';
import '../../../actions/action_withdraw/action_withdraw.dart';
import '../../../convert/view/convert.dart';

class ActionButton extends StatefulHookWidget {
  const ActionButton({
    Key? key,
    required this.transitionAnimationController,
  }) : super(key: key);

  final AnimationController transitionAnimationController;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isAnimating = true;
  ButtonState state = ButtonState.init;
  bool isTest = true;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final actionActive = useState(true);

    final isNotEmptyBalance = !isBalanceEmpty(currencies);

    void updateActionState() => actionActive.value = !actionActive.value;

    // final scaleAnimation1 = Tween(
    //   begin: 0.0,
    //   end: -64.0,
    // ).animate(
    //   CurvedAnimation(
    //     parent: animationController,
    //     curve: Curves.easeOut,
    //     reverseCurve: Curves.easeIn,
    //   ),
    // );

    final scaleAnimation = Tween(
      begin: 0.0,
      end: 80.0,
    ).animate(
      CurvedAnimation(
        parent: widget.transitionAnimationController,
        curve: Curves.linear,
      ),
    );

    final isStretched = isAnimating || state == ButtonState.init;

    final highlighted = useState(false);

    late Color currentNameColor;

    if (highlighted.value) {
      currentNameColor = colors.white.withOpacity(0.8);
    } else {
      currentNameColor = colors.white;
    }

    // print('is stretched =========== ${isStretched}');

    return Material(
      color: colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (scaleAnimation.value == 0) const SDivider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
              top: 23,
            ),
            child: AnimatedContainer(
              width: isTest ? MediaQuery.of(context).size.width : 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: isTest
                    ? BorderRadius.circular(16)
                    : BorderRadius.circular(100),
              ),
              duration: const Duration(milliseconds: 300),
              curve: isTest
                  ? const Cubic(0.42, 0, 0, 0.99)
                  : const Cubic(1, 0, 0.58, 1),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: isTest ? 1 : 0,
                    duration: Duration(milliseconds: isTest ? 150 : 300),
                    curve: isTest
                        ? Interval(
                            0.0,
                            0.5,
                            curve: isTest
                                ? const Cubic(0.42, 0, 0, 0.99)
                                : const Cubic(1, 0, 0.58, 1),
                          )
                        : Interval(
                            0.5,
                            1.0,
                            curve: isTest
                                ? const Cubic(0.42, 0, 0, 0.99)
                                : const Cubic(1, 0, 0.58, 1),
                          ),
                    child: InkWell(
                      child: Center(
                        child: Text(
                          isStretched ? 'Action' : '',
                          style: sButtonTextStyle.copyWith(
                            color: currentNameColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (actionActive.value) {
                          sShowMenuActionSheet(
                            context: context,
                            isNotEmptyBalance: isNotEmptyBalance,
                            onBuy: () => showBuyAction(context),
                            onSell: () => showSellAction(context),
                            onConvert: () =>
                                navigatorPush(context, const Convert()),
                            onDeposit: () => showDepositAction(context),
                            onWithdraw: () => showWithdrawAction(context),
                            onSend: () => showSendAction(context),
                            onReceive: () => showReceiveAction(context),
                            onDissmis: updateActionState,
                            whenComplete: () {
                              // if (actionActive.value) updateActionState();
                            },
                            transitionAnimationController:
                                widget.transitionAnimationController,
                          );
                          setState(() {
                            state = ButtonState.loading;
                          });
                        } else {
                          setState(() {
                            state = ButtonState.init;
                          });
                          Navigator.pop(context);
                        }
                        updateActionState();
                        setState(() {
                          isTest = !isTest;
                        });
                      },
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isTest ? 0 : 1,
                    duration: Duration(milliseconds: isTest ? 300 : 150),
                    curve: isTest
                        ? Interval(
                            0.0,
                            0.5,
                            curve: isTest
                                ? const Cubic(0.42, 0, 0, 0.99)
                                : const Cubic(1, 0, 0.58, 1),
                          )
                        : Interval(
                            0.5,
                            1.0,
                            curve: isTest
                                ? const Cubic(0.42, 0, 0, 0.99)
                                : const Cubic(1, 0, 0.58, 1),
                          ),
                    child: InkWell(
                      child: const Center(
                        child: SActionActiveIcon(),
                      ),
                      onTap: () {
                        if (actionActive.value) {
                          sShowMenuActionSheet(
                            context: context,
                            isNotEmptyBalance: isNotEmptyBalance,
                            onBuy: () => showBuyAction(context),
                            onSell: () => showSellAction(context),
                            onConvert: () =>
                                navigatorPush(context, const Convert()),
                            onDeposit: () => showDepositAction(context),
                            onWithdraw: () => showWithdrawAction(context),
                            onSend: () => showSendAction(context),
                            onReceive: () => showReceiveAction(context),
                            onDissmis: updateActionState,
                            whenComplete: () {
                              // if (actionActive.value) updateActionState();
                            },
                            transitionAnimationController:
                                widget.transitionAnimationController,
                          );
                          setState(() {
                            state = ButtonState.loading;
                          });
                        } else {
                          setState(() {
                            state = ButtonState.init;
                          });
                          Navigator.pop(context);
                        }
                        updateActionState();
                        setState(() {
                          isTest = !isTest;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ButtonState { init, loading, done }
