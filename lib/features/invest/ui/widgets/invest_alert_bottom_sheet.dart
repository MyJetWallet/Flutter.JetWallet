import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_button.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../utils/constants.dart';

void showInvestInfoBottomSheet({
  required BuildContext context,
  required String type,
  required Function() onPrimaryButtonTap,
  Function()? onSecondaryButtonTap,
  required String primaryButtonName,
  String? secondaryButtonName,
  Widget? bottomWidget,
  required String title,
  String? subtitle,
  bool removeWidgetSpace = false,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinnedBottom: Material(
      color: SColorsLight().white,
      child: Observer(
        builder: (BuildContext context) {
          return SizedBox(
            height: 98.0,
            child: Column(
              children: [
                const SpaceH20(),
                SPaddingH24(
                  child: Row(
                    children: [
                      Expanded(
                        child: SIButton(
                          activeColor: SColorsLight().grey5,
                          activeNameColor: SColorsLight().black,
                          inactiveColor: SColorsLight().grey2,
                          inactiveNameColor: SColorsLight().grey4,
                          active: true,
                          name: primaryButtonName,
                          onTap: () {
                            onPrimaryButtonTap();
                          },
                        ),
                      ),
                      if (secondaryButtonName != null) ...[
                        const SpaceW10(),
                        Expanded(
                          child: SIButton(
                            activeColor: SColorsLight().black,
                            activeNameColor: SColorsLight().white,
                            inactiveColor: SColorsLight().grey4,
                            inactiveNameColor: SColorsLight().grey2,
                            active: true,
                            icon: Assets.svg.invest.investClose.simpleSvg(
                              width: 20,
                              height: 20,
                            ),
                            name: secondaryButtonName,
                            onTap: () {
                              onSecondaryButtonTap?.call();
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SpaceH34(),
              ],
            ),
          );
        },
      ),
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [
      InfoBlock(
        type: type,
        title: title,
        subtitle: subtitle,
        bottomWidget: bottomWidget,
        removeWidgetSpace: removeWidgetSpace,
      ),
    ],
  );
}

class InfoBlock extends StatelessObserverWidget {
  const InfoBlock({
    super.key,
    required this.removeWidgetSpace,
    required this.type,
    required this.bottomWidget,
    required this.title,
    this.subtitle,
  });

  final bool removeWidgetSpace;
  final String type;
  final String title;
  final String? subtitle;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    final iconAsset = type == 'info'
        ? phoneChangeAsset
        : type == 'success'
            ? congratsAsset
            : type == 'pending'
                ? recurringBuysAsset
                : blockedAsset;

    return SPaddingH24(
      child: Column(
        children: [
          const SpaceH16(),
          Image.asset(
            iconAsset,
            width: 80,
            height: 80,
            package: 'simple_kit',
          ),
          const SpaceH16(),
          Text(
            title,
            style: STStyles.header2Invest.copyWith(
              color: SColorsLight().black,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
          ),
          if (subtitle != null) ...[
            const SpaceH8(),
            Text(
              subtitle!,
              style: STStyles.body1InvestM.copyWith(color: SColorsLight().grey1),
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
          ],
          const SpaceH16(),
          const SDivider(),
          if (bottomWidget != null) ...[
            if (!removeWidgetSpace) const SpaceH16(),
            bottomWidget!,
            if (!removeWidgetSpace) const SpaceH16(),
          ],
        ],
      ),
    );
  }
}
