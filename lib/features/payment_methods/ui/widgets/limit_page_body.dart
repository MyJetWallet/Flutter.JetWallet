import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_item.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_details/components/transaction_details_value_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';

class LimitPageBody extends StatelessObserverWidget {
  const LimitPageBody({
    Key? key,
    required this.cardLimit,
  }) : super(key: key);

  final CardLimitsModel cardLimit;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final currentWidth = MediaQuery.of(context).size.width - 48;
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

    String hoursLeftText() {
      final left = cardLimit.leftHours;
      final fullPart = left ~/ 24;
      if (left == 1) {
        return '1 ${intl.paymentMethodsSheet_hourLeft}';
      } else if (fullPart == 0) {
        return '$left ${intl.paymentMethodsSheet_hoursLeft}';
      } else if (fullPart == 1) {
        return '1 ${intl.paymentMethodsSheet_dayLeft}';
      } else if (fullPart > 1) {
        return '$fullPart ${intl.paymentMethodsSheet_daysLeft}';
      }

      return '1 ${intl.paymentMethodsSheet_hourLeft}';
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
                    color:
                        cardLimit.barProgress == 100 ? colors.red : colorToUse,
                  ),
                ),
              ),
            ],
          ),
          if (cardLimit.leftHours > 0) ...[
            const SpaceH10(),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: colors.grey5,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                child: Text(
                  hoursLeftText(),
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
            ),
            const SpaceH29(),
          ] else ...[
            const SpaceH42(),
          ],
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_minTransaction,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: cardLimit.minAmount,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
                onlyFullPart: true,
              ),
            ),
          ),
          const SpaceH19(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_maxTransaction,
            value: TransactionDetailsValueText(
              text: volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: cardLimit.maxAmount,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
                onlyFullPart: true,
              ),
            ),
          ),
          const SpaceH19(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_oneDay,
            value: TransactionDetailsValueText(
              text: checkLimitText(cardLimit.day1Amount, cardLimit.day1Limit),
              color: cardLimit.day1State == StateLimitType.active
                  ? colors.blue
                  : cardLimit.day1State == StateLimitType.block
                      ? colors.red
                      : colors.black,
            ),
          ),
          const SpaceH19(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_sevenDays,
            value: TransactionDetailsValueText(
              text: checkLimitText(cardLimit.day7Amount, cardLimit.day7Limit),
              color: cardLimit.day7State == StateLimitType.active
                  ? colors.blue
                  : cardLimit.day7State == StateLimitType.block
                      ? colors.red
                      : colors.black,
            ),
          ),
          const SpaceH19(),
          TransactionDetailsItem(
            text: intl.paymentMethodsSheet_thirtyDays,
            value: TransactionDetailsValueText(
              text: checkLimitText(cardLimit.day30Amount, cardLimit.day30Limit),
              color: cardLimit.day30State == StateLimitType.active
                  ? colors.blue
                  : cardLimit.day30State == StateLimitType.block
                      ? colors.red
                      : colors.black,
            ),
          ),
          if (cardLimitsLearnMoreLink.isNotEmpty) ...[
            const SpaceH19(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClickableUnderlinedText(
                  text: intl.earn_learn_more,
                  onTap: () {
                    sRouter.push(
                      HelpCenterWebViewRouter(
                        link: cardLimitsLearnMoreLink,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
          const SpaceH72(),
        ],
      ),
    );
  }
}
