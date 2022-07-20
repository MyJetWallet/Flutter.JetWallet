import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';
import 'dart:developer';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';

class LimitPageBody extends HookWidget {
  const LimitPageBody({
    Key? key,
    required this.cardLimit,
  }) : super(key: key);

  final CardLimitsModel cardLimit;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    final currentWidth = MediaQuery.of(context).size.width - 48;
    final width = currentWidth / 100 * cardLimit.barProgress;
    final isWidthDifferenceSmall = (currentWidth - width) < 6;

    String checkLimitText(Decimal amount, Decimal limit) {
      return '${volumeFormat(
        prefix: baseCurrency.prefix,
        decimal: amount,
        symbol: baseCurrency.symbol,
        accuracy: baseCurrency.accuracy,
        onlyFullPart: true,
      )} / ${volumeFormat(
        prefix: baseCurrency.prefix,
        decimal: limit,
        symbol: baseCurrency.symbol,
        accuracy: baseCurrency.accuracy,
        onlyFullPart: true,
      )}';
    }

    return SPaddingH24(
      child: Column(
        children: [
          Text(
            intl.paymentMethodsSheet_cardsLimit,
            style: sTextH1Style.copyWith(
              color: colors.black,
            ),
          ),
          const SpaceH13(),
          Text(
            intl.paymentMethodsSheet_cardsLimitDescription,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
          const SpaceH33(),
          Stack(
            children: [
              Container(
                width: currentWidth,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: colors.blueLight,
                ),
              ),
              Positioned(
                child: Container(
                  width: width,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(6),
                      bottomLeft: const Radius.circular(6),
                      topRight: isWidthDifferenceSmall
                          ? const Radius.circular(6)
                          : Radius.zero,
                      bottomRight: isWidthDifferenceSmall
                          ? const Radius.circular(6)
                          : Radius.zero,
                    ),
                    color: cardLimit.barProgress == 100
                      ? colors.red
                      : colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SpaceH72(),
        ],
      ),
    );
  }
}
