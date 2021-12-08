import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SActionConfirmText extends StatelessWidget {
  const SActionConfirmText({
    Key? key,
    this.valueColor,
    this.animation,
    this.timerLoading = false,
    this.contentLoading = false,
    required this.name,
    required this.value,
  }) : super(key: key);

  final Color? valueColor;
  // Needed to display Timer
  final AnimationController? animation;
  // Needed to display Timer
  final bool timerLoading;
  final bool contentLoading;
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Baseline(
              baseline: 40.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                name,
                maxLines: 10,
                style: sBodyText2Style.copyWith(
                  color: SColorsLight().grey1,
                ),
              ),
            ),
          ),
          const SpaceW10(),
          if (contentLoading)
            const Baseline(
              baseline: 40.0,
              baselineType: TextBaseline.alphabetic,
              child: SSkeletonTextLoader(),
            )
          else
            Container(
              constraints: BoxConstraints(
                maxWidth: animation != null ? 200.0 : 180.0,
                minWidth: 100.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: sSubtitle3Style.copyWith(
                        color: valueColor ?? SColorsLight().black,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  if (animation != null) ...[
                    const SpaceW10(),
                    Baseline(
                      baseline: 17.0,
                      baselineType: TextBaseline.alphabetic,
                      child: SConfirmActionTimer(
                        animation: animation!,
                        loading: timerLoading,
                      ),
                    ),
                  ]
                ],
              ),
            ),
        ],
      ),
    );
  }
}
