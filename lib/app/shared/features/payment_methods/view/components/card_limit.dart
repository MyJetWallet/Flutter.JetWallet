import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import 'card_limits_bottom_sheet.dart';

class CardLimit extends HookWidget {
  const CardLimit({
    Key? key,
    required this.cardLimit,
    this.small = false,
  }) : super(key: key);

  final CardLimitsModel cardLimit;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    final currentWidth = MediaQuery.of(context).size.width - 48;
    var width = currentWidth / 100 * cardLimit.barProgress;
    var colorToUse = colors.blue;
    var isWidthDifferenceSmall = (currentWidth - width) < 6;
    if (cardLimit.day1State == StateLimitType.block
        || cardLimit.day7State == StateLimitType.block
        || cardLimit.day30State == StateLimitType.block) {
      isWidthDifferenceSmall = true;
      width = currentWidth;
      colorToUse = colors.red;
    }

    String checkLimitText() {
      var amount = Decimal.zero;
      var limit = Decimal.zero;
      if (cardLimit.day1State == StateLimitType.block) {
        amount = cardLimit.day1Amount;
        limit = cardLimit.day1Limit;
      } else if (cardLimit.day7State == StateLimitType.block) {
        amount = cardLimit.day7Amount;
        limit = cardLimit.day7Limit;
      } else if (cardLimit.day30State == StateLimitType.block) {
        amount = cardLimit.day30Amount;
        limit = cardLimit.day30Limit;
      } else if (cardLimit.barInterval == StateBarType.day1) {
        amount = cardLimit.day1Amount;
        limit = cardLimit.day1Limit;
      } else if (cardLimit.barInterval == StateBarType.day7) {
        amount = cardLimit.day7Amount;
        limit = cardLimit.day7Limit;
      } else {
        amount = cardLimit.day30Amount;
        limit = cardLimit.day30Limit;
      }
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

    final text = '${
      (cardLimit.barInterval == StateBarType.day1 ||
          cardLimit.day1State == StateLimitType.block)
        ? intl.paymentMethods_oneDay
        : (cardLimit.barInterval == StateBarType.day7 ||
          cardLimit.day7State == StateLimitType.block)
        ? intl.paymentMethods_sevenDays
        : intl.paymentMethods_thirtyDays
    } ${intl.paymentMethods_cardsLimit}: ${checkLimitText()}';

    return SPaddingH24(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                text,
                style: sSubtitle3Style.copyWith(
                  color: colors.grey1,
                ),
              ),
              const Spacer(),
              SIconButton(
                onTap: () {
                  showCardLimitsBottomSheet(
                    context: context,
                    cardLimits: cardLimit,
                  );
                },
                defaultIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: SInfoIcon(color: colors.grey3),
                ),
              ),
            ],
          ),
          const SpaceH13(),
          Stack(
            children: [
              Container(
                width: currentWidth,
                height: small ? 4 : 12,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: colors.blueLight,
                ),
              ),
              Positioned(
                child: Container(
                  width: width,
                  height: small ? 4 : 12,
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
                      : colorToUse,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
