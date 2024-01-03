import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

enum SActionedType { basic, inverted }

class SActioned extends StatelessWidget {
  const SActioned({
    super.key,
    this.icon,
    required this.label,
    this.supplement,
    required this.button,
    this.type = SActionedType.basic,
  });

  final Widget? icon;
  final String label;
  final String? supplement;
  final SButtonContext button;
  final SActionedType type;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      height: 64,
      color: type == SActionedType.basic ? colors.white : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: STStyles.subtitle2.copyWith(
                                  leadingDistribution: TextLeadingDistribution.even,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (supplement != null)
                                Text(
                                  supplement ?? '',
                                  style: STStyles.body2Medium.copyWith(
                                    color: colors.gray10,
                                    leadingDistribution: TextLeadingDistribution.even,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      button,
                    ],
                  ),
                  const SizedBox(
                    height: 47,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: colors.gray4,
          ),
        ],
      ),
    );
  }
}
