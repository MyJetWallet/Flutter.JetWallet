import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SFiatItem extends StatelessWidget {
  const SFiatItem({
    Key? key,
    this.isSelected = false,
    required this.icon,
    required this.name,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final Widget icon;
  final String name;
  final String amount;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final mainColor = isSelected ? SColorsLight().blue : SColorsLight().black;

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 88,
          child: Column(
            children: [
              const SpaceH34(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW20(),
                  Expanded(
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        SizedBox(
                          width: 150.0,
                          child: Baseline(
                            baseline: 15.8,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              name,
                              style: sSubtitle2Style.copyWith(
                                color: mainColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 120.0,
                          child: Text(
                            amount,
                            textAlign: TextAlign.end,
                            style: sSubtitle2Style.copyWith(
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SDivider(
                width: 327.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
