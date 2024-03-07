import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_text_button.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

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

  @override
  Widget build(BuildContext context) {

    final colors = sKit.colors;

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
              SIconButton(
                defaultIcon: Assets.svg.invest.setting.simpleSvg(width: 16, height: 16,),
                pressedIcon: Assets.svg.invest.setting.simpleSvg(width: 16, height: 16,),
                onTap: onButtonTap,
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
                icon: Assets.svg.invest.report.simpleSvg(width: 16, height: 16,),
              ),
            if (showModify)
              SITextButton(
                active: true,
                name: intl.invest_modify,
                onTap: () {
                  onButtonTap?.call();
                },
                icon: Assets.svg.invest.edit.simpleSvg(width: 16, height: 16,),
              ),
          ],
        ),
        const SpaceH4(),
      ],
    );
  }
}
