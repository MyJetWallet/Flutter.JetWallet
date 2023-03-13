import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:logger/logger.dart';

import '../../../core/di/di.dart';
import '../../../core/services/logger_service/logger_service.dart';

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
    getIt.get<SimpleLoggerService>().log(
      level: Level.info,
      place: 'CircleActionButtons',
      message: 'start',
    );
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
    getIt.get<SimpleLoggerService>().log(
      level: Level.info,
      place: 'CircleActionButtons',
      message: '$countOfActive',
    );
    // final widthOfSpaces = 8 * (countOfActive - 1);
    // final widthOfBlock = countOfActive < 3
    //     ? 108
    //     : (MediaQuery.of(context).size.width - widthOfSpaces - 48) / countOfActive;
    // getIt.get<SimpleLoggerService>().log(
    //   level: Level.info,
    //   place: 'CircleActionButtons widthOfSpaces',
    //   message: '$widthOfSpaces',
    // );
    // getIt.get<SimpleLoggerService>().log(
    //   level: Level.info,
    //   place: 'CircleActionButtons widthOfBlock',
    //   message: '$widthOfBlock',
    // );
    // getIt.get<SimpleLoggerService>().log(
    //   level: Level.info,
    //   place: 'CircleActionButtons size.width',
    //   message: '${MediaQuery.of(context).size.width}',
    // );

    return SPaddingH24(
      // child: SizedBox(
      //   width: MediaQuery.of(context).size.width - 48,
        child: Row(
          // mainAxisAlignment: countOfActive > 2
          //     ? MainAxisAlignment.spaceBetween
          //     : MainAxisAlignment.center,
          children: [
            if (showBuy)
              SizedBox(
                // width: widthOfBlock.toDouble(),
                child: Center(
                  child: CircleActionBuy(
                    onTap: () {
                      onBuy?.call();
                    },
                  ),
                ),
              ),
            if (showReceive)
              SizedBox(
                // width: widthOfBlock.toDouble(),
                child: Center(
                  child: CircleActionReceive(
                    onTap: () {
                      onReceive?.call();
                    },
                  ),
                ),
              ),
            if (showSend)
              SizedBox(
                // width: widthOfBlock.toDouble(),
                child: Center(
                  child: CircleActionSend(
                    onTap: () {
                      onSend?.call();
                    },
                  ),
                ),
              ),
            if (showExchange)
              SizedBox(
                // width: widthOfBlock.toDouble(),
                child: Center(
                  child: CircleActionExchange(
                    onTap: () {
                      onExchange?.call();
                    },
                  ),
                ),
              ),
          ],
        ),
      // ),
    );
  }
}
