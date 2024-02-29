import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class AboveListLine extends StatelessObserverWidget {
  const AboveListLine({
    super.key,
    required this.mainColumn,
    required this.secondaryColumn,
    required this.lastColumn,
    this.withCheckbox = false,
    this.checked = false,
    this.withSort = false,
    required this.onCheckboxTap,
    this.onSortTap,
    this.sortState = 0,
  });

  final String mainColumn;
  final String secondaryColumn;
  final String lastColumn;
  final bool withCheckbox;
  final bool checked;
  final bool withSort;
  final Function(bool) onCheckboxTap;
  final Function()? onSortTap;
  final int sortState;

  @override
  Widget build(BuildContext context) {

    final colors = sKit.colors;

    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      child: Column(
        children: [
          const SpaceH4(),
          Row(
            children: [
              Row(
                children: [
                  if (withCheckbox) ...[
                    SIconButton(
                      onTap: () {
                        onCheckboxTap(!checked);
                      },
                      defaultIcon: checked
                          ? Assets.svg.invest.checked.simpleSvg(width: 20, height: 20,)
                          : Assets.svg.invest.check.simpleSvg(width: 20, height: 20,),
                      pressedIcon: checked
                          ? Assets.svg.invest.checked.simpleSvg(width: 20, height: 20,)
                          : Assets.svg.invest.check.simpleSvg(width: 20, height: 20,),
                    ),
                    const SpaceW4(),
                  ],
                ],
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  if (withCheckbox) {
                    onCheckboxTap(!checked);
                  }
                },
                child: Text(
                  mainColumn,
                  style: withCheckbox
                      ? STStyles.body2InvestM.copyWith(
                    color: colors.black,
                  )
                      : STStyles.body3InvestM.copyWith(
                    color: colors.grey2,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                secondaryColumn,
                style: STStyles.body3InvestSM.copyWith(
                  color: colors.grey2,
                ),
              ),
              const SpaceW24(),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  onSortTap?.call();
                },
                child: Text(
                  lastColumn,
                  style: STStyles.body3InvestSM.copyWith(
                    color: colors.grey2,
                  ),
                ),
              ),
              if (withSort) ...[
                const SpaceW2(),
                SIconButton(
                  onTap: () {
                    onSortTap?.call();
                  },
                  defaultIcon: sortState == 0
                    ? Assets.svg.invest.sortNotSet.simpleSvg(width: 14, height: 14,)
                    : sortState == 1
                    ? Assets.svg.invest.sortUp.simpleSvg(width: 14, height: 14,)
                    : Assets.svg.invest.sortDown.simpleSvg(width: 14, height: 14,),
                  pressedIcon: sortState == 0
                      ? Assets.svg.invest.sortNotSet.simpleSvg(width: 14, height: 14,)
                      : sortState == 1
                      ? Assets.svg.invest.sortUp.simpleSvg(width: 14, height: 14,)
                      : Assets.svg.invest.sortDown.simpleSvg(width: 14, height: 14,),
                ),
              ],
            ],
          ),
          const SpaceH4(),
          const SDivider(),
        ],
      ),
    );
  }
}
