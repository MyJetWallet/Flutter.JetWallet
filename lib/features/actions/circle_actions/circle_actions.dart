import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_convert.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_sell.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleActionButtons extends StatelessObserverWidget {
  const CircleActionButtons({
    super.key,
    this.isBuyDisabled = false,
    this.isSellDisabled = false,
    this.isReceiveDisabled = false,
    this.isSendDisabled = false,
    this.isExchangeDisabled = false,
    this.isConvertDisabled = false,
    this.onBuy,
    this.onSell,
    this.onReceive,
    this.onSend,
    this.onExchange,
    this.onConvert,
  });

  final bool isBuyDisabled;
  final bool isSellDisabled;
  final bool isReceiveDisabled;
  final bool isSendDisabled;
  final bool isExchangeDisabled;
  final bool isConvertDisabled;
  final Function()? onBuy;
  final Function()? onSell;
  final Function()? onReceive;
  final Function()? onSend;
  final Function()? onExchange;
  final Function()? onConvert;

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
            CircleActionSell(
              onTap: () {
                onSell?.call();
              },
              isDisabled: isSellDisabled,
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
            CircleActionConvert(
              onTap: () {
                onConvert?.call();
              },
              isDisabled: isConvertDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
