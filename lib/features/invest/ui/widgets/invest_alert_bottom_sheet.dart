import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit/simple_kit.dart';

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
  showBasicBottomSheet(
    context: context,
    button: Material(
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
                          activeColor: SColorsLight().gray2,
                          activeNameColor: SColorsLight().black,
                          inactiveColor: SColorsLight().gray8,
                          inactiveNameColor: SColorsLight().gray10,
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
                            inactiveColor: SColorsLight().gray10,
                            inactiveNameColor: SColorsLight().gray8,
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
              style: STStyles.body1InvestM.copyWith(color: SColorsLight().gray10),
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
