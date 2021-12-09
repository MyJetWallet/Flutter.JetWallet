import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SPaymentSelectFiat extends StatelessWidget {
  const SPaymentSelectFiat({
    Key? key,
    required this.icon,
    required this.name,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  final Widget icon;
  final String name;
  final String amount;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: InkWell(
        highlightColor: SColorsLight().grey4,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Ink(
          height: 88.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: SColorsLight().grey4,
            ),
          ),
          child: Column(
            children: [
              const SpaceH30(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceW20(),
                  icon,
                  const SpaceW10(),
                  Expanded(
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        SizedBox(
                          width: 130.0,
                          child: Baseline(
                            baseline: 17.0,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              name,
                              style: sSubtitle2Style,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 110.0,
                          child: Text(
                            amount,
                            textAlign: TextAlign.end,
                            style: sSubtitle2Style,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceW20(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
