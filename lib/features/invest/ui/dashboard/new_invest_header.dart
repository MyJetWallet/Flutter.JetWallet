import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

import '../../../../core/l10n/i10n.dart';

class NewInvestHeader extends StatelessObserverWidget {
  const NewInvestHeader({
    super.key,
    required this.showRollover,
    required this.showModify,
    required this.showIcon,
    required this.showFull,
    this.showEdit = false,
    required this.title,
    this.haveActiveInvest = false,
    this.showTextButton = false,
    this.textButtonName = '',
    this.onButtonTap,
    this.showViewAll = false,
  });

  final bool showRollover;
  final bool showModify;
  final bool showIcon;
  final bool haveActiveInvest;
  final bool showFull;
  final bool showEdit;
  final bool showTextButton;
  final String title;
  final String textButtonName;
  final Function()? onButtonTap;
  final bool showViewAll;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Column(
      children: [
        const SpaceH4(),
        Row(
          children: [
            if (haveActiveInvest) ...[
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: colors.green,
                ),
              ),
              const SpaceW2(),
            ],
            Text(
              title,
              style: STStyles.header4SMInvest.copyWith(
                color: colors.black,
              ),
            ),
            const Spacer(),
            if (showIcon)
              SafeGesture(
                onTap: onButtonTap,
                child: Assets.svg.invest.setting.simpleSvg(
                  width: 16,
                  height: 16,
                ),
              ),
            if (showRollover)
              SITextButton(
                active: true,
                name: intl.invest_rollover_report,
                onTap: () {
                  onButtonTap?.call();
                },
              ),
            if (showTextButton)
              SITextButton(
                active: true,
                name: textButtonName,
                onTap: () {
                  onButtonTap?.call();
                },
              ),
            if (showFull)
              SITextButton(
                active: true,
                name: intl.invest_full_report,
                onTap: () {
                  onButtonTap?.call();
                },
                icon: Assets.svg.invest.report.simpleSvg(
                  width: 16,
                  height: 16,
                ),
              ),
            if (showModify)
              SITextButton(
                active: true,
                name: intl.invest_modify,
                onTap: () {
                  onButtonTap?.call();
                },
                icon: Assets.svg.invest.edit.simpleSvg(
                  width: 16,
                  height: 16,
                ),
              ),
            if (showViewAll)
              InkWell(
                onTap: () {
                  onButtonTap?.call();
                },
                child: Row(
                  children: [
                    Text(
                      intl.invest_all_coins,
                      style: STStyles.header4SMInvest.copyWith(
                        color: colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.5),
                      child: Assets.svg.medium.shevronRight.simpleSvg(
                        width: 16,
                        height: 16,
                        color: colors.gray8,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SpaceH4(),
      ],
    );
  }
}
