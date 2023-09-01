import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'card_limits_bottom_sheet.dart';

class CardLimit extends StatelessObserverWidget {
  const CardLimit({
    super.key,
    required this.cardLimit,
    this.small = false,
  });

  final CardLimitsModel cardLimit;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final currentWidth = MediaQuery.of(context).size.width - 130;
    var width = currentWidth / 100 * cardLimit.barProgress;
    var colorToUse = colors.blue;
    var isWidthDifferenceSmall = (currentWidth - width) < 6;
    if (cardLimit.day1State == StateLimitType.block ||
        cardLimit.day7State == StateLimitType.block ||
        cardLimit.day30State == StateLimitType.block) {
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

    final text =
        '''${(cardLimit.barInterval == StateBarType.day1 || cardLimit.day1State == StateLimitType.block) ? intl.paymentMethods_oneDay : (cardLimit.barInterval == StateBarType.day7 || cardLimit.day7State == StateLimitType.block) ? intl.paymentMethods_sevenDays : intl.paymentMethods_thirtyDays} ${intl.paymentMethods_cardsLimit}: ${checkLimitText()}''';

    return SPaddingH24(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: colors.grey5,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: 12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: sSubtitle3Style.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                      const SpaceH13(),
                      Stack(
                        children: [
                          Container(
                            width: currentWidth,
                            height: small ? 4 : 12,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              color: colors.grey4,
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
                  const SpaceW16(),
                  SIconButton(
                    onTap: () {
                      showCardLimitsBottomSheet(
                        context: context,
                        cardLimits: cardLimit,
                      );
                    },
                    defaultIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: SInfoIcon(color: colors.grey3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
