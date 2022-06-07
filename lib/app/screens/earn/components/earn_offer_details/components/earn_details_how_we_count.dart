import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../shared/features/market_details/view/components/about_block/components/clickable_underlined_text.dart';
import '../../../../../shared/helpers/formatting/formatting.dart';
import '../../../../account/components/help_center_web_view.dart';

void showDetailsHowWeCountSheet({
  required BuildContext context,
  required List<SimpleTierModel> tiers,
  required SimpleColors colors,
  required bool isHot,
  required String title,
  required String subtitle,
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
                '${marketFormat(
              prefix: '\$',
              decimal: Decimal.parse(tiers[i].fromUsd),
              accuracy: 0,
              symbol: 'USD',
            )}-${marketFormat(
              prefix: '\$',
              decimal: Decimal.parse(tiers[i].toUsd),
              accuracy: 0,
              symbol: 'USD',
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
          value: '\$${tiers[0].fromUsd}-${tiers[0].toUsd}',
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
              HelpCenterWebView.push(
                context: context,
                link: infoEarnLink,
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
