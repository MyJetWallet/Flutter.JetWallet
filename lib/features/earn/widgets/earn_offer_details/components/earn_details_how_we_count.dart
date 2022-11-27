import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

void showDetailsHowWeCountSheet({
  required BuildContext context,
  required List<SimpleTierModel> tiers,
  required SimpleColors colors,
  required bool isHot,
  required String title,
  required String subtitle,
  required CurrencyModel currency,
}) {
  final colorTheme = isHot
      ? [colors.orange, colors.brown, colors.darkBrown]
      : [colors.seaGreen, colors.leafGreen, colors.aquaGreen];

  sShowBasicModalBottomSheet(
    horizontalPadding: 24,
    children: [
      const SpaceH4(),
      Center(
        child: AutoSizeText(
          title,
          textAlign: TextAlign.center,
          minFontSize: 4.0,
          maxLines: 1,
          strutStyle: const StrutStyle(
            height: 1.20,
            fontSize: 40.0,
            fontFamily: 'Gilroy',
          ),
          style: TextStyle(
            height: 1.20,
            fontSize: 40.0,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: colors.black,
          ),
        ),
      ),
      const SpaceH11(),
      Center(
        child: Text(
          subtitle,
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
      ),
      const SpaceH35(),
      Row(
        children: [
          SimplePercentageIndicator(
            tiers: tiers,
            isHot: isHot,
            expanded: true,
          ),
        ],
      ),
      const SpaceH24(),
      if (!(tiers.length == 1))
        for (var i = 0; i < tiers.length; i++)
          SActionConfirmText(
            name: 'Tier ${i + 1} APY (limit: '
                '${volumeFormat(
              decimal: Decimal.parse(tiers[i].from),
              accuracy: currency.accuracy,
              prefix: '',
              symbol: '',
            )}-${volumeFormat(
              decimal: Decimal.parse(tiers[i].to),
              accuracy: currency.accuracy,
              symbol: currency.symbol,
            )})',
            baseline: 35.0,
            value: '${tiers[i].apy}%',
            valueColor: i == 0
                ? colorTheme[0]
                : i == 1
                    ? colorTheme[1]
                    : colorTheme[2],
            minValueWidth: 50,
            maxValueWidth: 50,
          )
      else ...[
        SActionConfirmText(
          name: 'Limit',
          baseline: 35.0,
          value: '${volumeFormat(
            prefix: '',
            decimal: Decimal.parse(tiers[0].from),
            accuracy: currency.accuracy,
            symbol: '',
          )}-${volumeFormat(
            decimal: Decimal.parse(tiers[0].to),
            accuracy: currency.accuracy,
            symbol: currency.symbol,
          )}',
          minValueWidth: 50,
          maxValueWidth: 200,
        ),
        SActionConfirmText(
          name: 'APY',
          baseline: 35.0,
          value: '${tiers[0].apy}%',
          minValueWidth: 50,
          maxValueWidth: 50,
        ),
      ],
      const SpaceH19(),
      Row(
        children: [
          ClickableUnderlinedText(
            text: 'Learn more',
            onTap: () {
              sRouter.push(
                HelpCenterWebViewRouter(
                  link: infoEarnLink,
                ),
              );
            },
          ),
        ],
      ),
      const SpaceH40(),
    ],
    context: context,
  );
}
