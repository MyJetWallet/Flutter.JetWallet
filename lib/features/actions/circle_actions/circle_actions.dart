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
    required this.showBuy,
    required this.showReceive,
    required this.showSend,
    required this.showExchange,
    this.onBuy,
    this.onReceive,
    this.onSend,
    this.onExchange,
  });

  final bool showBuy;
  final bool showReceive;
  final bool showSend;
  final bool showExchange;
  final Function()? onBuy;
  final Function()? onReceive;
  final Function()? onSend;
  final Function()? onExchange;

  @override
  Widget build(BuildContext context) {
    var countOfActive = 0;
    if (showBuy) {
      countOfActive++;
    }
    if (showReceive) {
      countOfActive++;
    }
    if (showSend) {
      countOfActive++;
    }
    if (showExchange) {
      countOfActive++;
    }

    return SPaddingH24(
      child: SizedBox(
        width: countOfActive > 2
            ? MediaQuery.of(context).size.width - 48
            : 216,
        child: Row(
          mainAxisAlignment: countOfActive > 2
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (showBuy)
              CircleActionBuy(
                onTap: () {
                  onBuy?.call();
                },
              ),
            if (showReceive)
              CircleActionReceive(
                onTap: () {
                  onReceive?.call();
                },
              ),
            if (showSend)
              CircleActionSend(
                onTap: () {
                  onSend?.call();
                },
              ),
            if (showExchange)
              CircleActionExchange(
                onTap: () {
                  onExchange?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}
