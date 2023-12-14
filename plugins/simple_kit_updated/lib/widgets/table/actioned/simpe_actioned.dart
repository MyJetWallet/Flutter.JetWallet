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
    required this.buttonLabale,
    this.buttonContentCollor,
    this.buttonIcon,
    this.opPress,
    this.type = SActionedType.basic,
  });

  final Widget? icon;
  final String label;
  final String? supplement;
  final String buttonLabale;
  final Color? buttonContentCollor;
  final Widget? buttonIcon;
  final void Function()? opPress;
  final SActionedType type;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      height: 64,
      color: type == SActionedType.basic ? colors.white : Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                              style: STStyles.subtitle2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (supplement != null)
                              Text(
                                supplement ?? '',
                                style: STStyles.body2Medium.copyWith(color: colors.gray10),
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
                    Container(
                      decoration: BoxDecoration(
                        color: type == SActionedType.basic ? Colors.transparent : SColorsLight().white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SButtonContext(
                        text: buttonLabale,
                        onTap: opPress,
                        contentColor: buttonContentCollor,
                        icon: buttonIcon,
                        type: type == SActionedType.basic
                            ? SButtonContextType.iconedSmall
                            : SButtonContextType.iconedSmallInverted,
                      ),
                    ),
                  ],
                )
              ],
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
