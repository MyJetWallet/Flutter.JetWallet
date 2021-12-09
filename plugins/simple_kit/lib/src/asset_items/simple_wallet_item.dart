import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SWalletItem extends StatelessWidget {
  const SWalletItem({
    Key? key,
    this.amount,
    this.decline,
    this.removeDivider = false,
    this.color,
    this.onTap,
    required this.icon,
    required this.primaryText,
    required this.secondaryText,
  }) : super(key: key);

  final bool? decline;
  final String? amount;
  final bool removeDivider;
  final Color? color;
  final Function()? onTap;
  final Widget icon;
  final String primaryText;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    var textColor = SColorsLight().green;
    var borderColor = SColorsLight().greenLight;
    final formattedAmount = amount == '\$0.00' ? '\$0' : amount;

    if (decline ?? false) {
      textColor = SColorsLight().red;
      borderColor = SColorsLight().redLight;
    }

    return InkWell(
      highlightColor: SColorsLight().grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 88.0,
          child: Column(
            children: [
              const SpaceH22(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon,
                  const SpaceW10(),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Baseline(
                          baseline: 17.8,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            primaryText,
                            style: sSubtitle2Style,
                          ),
                        ),
                        Baseline(
                          baseline: 19.4,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            secondaryText,
                            style: sBodyText2Style.copyWith(
                              color: SColorsLight().grey3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (amount != null) ...[
                    const SpaceW10(),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 157.0,
                      ),
                      height: 44.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formattedAmount!,
                            style: sSubtitle2Style.copyWith(
                              color:
                                  formattedAmount == '\$0' ? color : textColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              ),
              const Spacer(),
              if (!removeDivider)
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
