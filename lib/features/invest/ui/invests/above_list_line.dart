import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

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
                          ? const SICheckedIcon(width: 20, height: 20,)
                          : const SICheckIcon(width: 20, height: 20,),
                      pressedIcon: checked
                          ? const SICheckedIcon(width: 20, height: 20,)
                          : const SICheckIcon(width: 20, height: 20,),
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
                      ? sBody2InvestMStyle.copyWith(
                    color: colors.black,
                  )
                      : sBody3InvestMStyle.copyWith(
                    color: colors.grey2,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                secondaryColumn,
                style: sBody3InvestSMStyle.copyWith(
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
                  style: sBody3InvestSMStyle.copyWith(
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
                    ? const SISortNotSetIcon(width: 14, height: 14,)
                    : sortState == 1
                    ? const SISortUpIcon(width: 14, height: 14,)
                    : const SISortDownIcon(width: 14, height: 14,),
                  pressedIcon: sortState == 0
                    ? const SISortNotSetIcon(width: 14, height: 14,)
                    : sortState == 1
                    ? const SISortUpIcon(width: 14, height: 14,)
                    : const SISortDownIcon(width: 14, height: 14,),
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
