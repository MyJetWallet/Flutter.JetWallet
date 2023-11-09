import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SActionConfirmText extends StatelessWidget {
  const SActionConfirmText({
    Key? key,
    this.infoAction,
    this.baseline,
    this.valueColor,
    this.valueDescription,
    this.animation,
    this.icon,
    this.timerLoading = false,
    this.contentLoading = false,
    this.infoIcon = false,
    this.minValueWidth = 100,
    this.maxValueWidth = 180,
    required this.name,
    required this.value,
  }) : super(key: key);

  /// Needed for cases when SActionConfirmText goes after SActionConfirmText
  /// Because SActionConfirmText gives + 4px in height
  /// because of the text height
  final Function()? infoAction;
  final double? baseline;
  final Color? valueColor;
  final String? valueDescription;
  // Needed to display Timer
  final AnimationController? animation;
  // Needed to display Timer
  final bool timerLoading;
  final bool contentLoading;
  final bool infoIcon;
  final String name;
  final String value;
  final double minValueWidth;
  final double maxValueWidth;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Baseline(
      baseline: baseline ?? 40.0,
      baselineType: TextBaseline.alphabetic,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Baseline(
              baseline: 19.0,
              baselineType: TextBaseline.alphabetic,
              child: infoIcon
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 10,
                          style: sBodyText2Style.copyWith(
                            color: SColorsLight().grey1,
                          ),
                        ),
                        const SpaceW12(),
                        SIconButton(
                          onTap: () {
                            infoAction?.call();
                          },
                          defaultIcon: SInfoIcon(
                            color: SColorsLight().grey1,
                          ),
                        ),
                      ],
                    )
                  : Text(
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
              baseline: 19.0,
              baselineType: TextBaseline.alphabetic,
              child: SSkeletonTextLoader(
                height: 16,
                width: 80,
              ),
            )
          else
            Container(
              constraints: BoxConstraints(
                maxWidth: animation != null ? 200.0 : maxValueWidth,
                minWidth: minValueWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SpaceW8(),
                      ],
                      Flexible(
                        child: Text(
                          value,
                          style: sSubtitle3Style.copyWith(
                            color: valueColor ?? SColorsLight().black,
                          ),
                          maxLines: 3,
                          textAlign: icon != null ? TextAlign.start : TextAlign.end,
                        ),
                      ),
                      if (animation != null) ...[
                        const SpaceW10(),
                        Baseline(
                          baseline: -4.0,
                          baselineType: TextBaseline.alphabetic,
                          child: SConfirmActionTimer(
                            animation: animation!,
                            loading: timerLoading,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (valueDescription != null)
                    Baseline(
                      baseline: 15.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        valueDescription!,
                        style: sBodyText2Style.copyWith(
                          color: SColorsLight().grey1,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
