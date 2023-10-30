import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleActionButtons extends StatelessObserverWidget {
  const CircleActionButtons({
    super.key,
    this.isBuyDisabled = false,
    this.isReceiveDisabled = false,
    this.isSendDisabled = false,
    this.isExchangeDisabled = false,
    this.onBuy,
    this.onReceive,
    this.onSend,
    this.onExchange,
  });

  final bool isBuyDisabled;
  final bool isReceiveDisabled;
  final bool isSendDisabled;
  final bool isExchangeDisabled;
  final Function()? onBuy;
  final Function()? onReceive;
  final Function()? onSend;
  final Function()? onExchange;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleActionBuy(
              onTap: () {
                onBuy?.call();
              },
              isDisabled: isBuyDisabled,
            ),
            CircleActionReceive(
              onTap: () {
                onReceive?.call();
              },
              isDisabled: isReceiveDisabled,
            ),
            CircleActionSend(
              onTap: () {
                onSend?.call();
              },
              isDisabled: isSendDisabled,
            ),
            CircleActionExchange(
              onTap: () {
                onExchange?.call();
              },
              isDisabled: isExchangeDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
