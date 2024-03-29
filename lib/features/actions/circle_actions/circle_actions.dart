import 'package:flutter/material.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_convert.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_sell.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleActionButtons extends StatelessWidget {
  const CircleActionButtons({
    super.key,
    this.isBuyDisabled = false,
    this.isSellDisabled = false,
    this.isReceiveDisabled = false,
    this.isSendDisabled = false,
    this.isConvertDisabled = false,
    this.onBuy,
    this.onSell,
    this.onReceive,
    this.onSend,
    this.onConvert,
  });

  final bool isBuyDisabled;
  final bool isSellDisabled;
  final bool isReceiveDisabled;
  final bool isSendDisabled;
  final bool isConvertDisabled;
  final Function()? onBuy;
  final Function()? onSell;
  final Function()? onReceive;
  final Function()? onSend;
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
            CircleActionSend(
              onTap: () {
                onSend?.call();
              },
              isDisabled: isSendDisabled,
            ),
            CircleActionReceive(
              onTap: () {
                onReceive?.call();
              },
              isDisabled: isReceiveDisabled,
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
