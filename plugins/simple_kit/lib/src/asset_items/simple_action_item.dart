import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SActionItem extends StatelessWidget {
  const SActionItem({
    Key? key,
    this.helper = '',
    required this.icon,
    required this.name,
    required this.onTap,
    required this.description,
  }) : super(key: key);

  final String helper;
  final Widget icon;
  final String name;
  final Function() onTap;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 64.0,
          child: Column(
            children: [
              const SpaceH10(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW20(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            SizedBox(
                              width: 177.0,
                              child: Baseline(
                                baseline: 17.8,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  name,
                                  style: sSubtitle2Style,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 90.0,
                              child: Text(
                                helper,
                                textAlign: TextAlign.end,
                                style: sCaptionTextStyle.copyWith(
                                  color: SColorsLight().grey3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Baseline(
                          baseline: 15.5,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            description,
                            style: sCaptionTextStyle.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
