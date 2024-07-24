import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ChipsSuggestionM extends HookWidget {
  const ChipsSuggestionM({
    this.title,
    this.subtitle,
    this.value,
    required this.onTap,
    this.icon,
    super.key,
  });
  final String? title;
  final String? subtitle;
  final String? value;
  final void Function()? onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final isHighlated = useState(false);

    return SafeGesture(
      onTap: onTap,
      highlightColor: colors.gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isHighlated.value ? colors.gray2 : Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 12,
            top: 14,
            bottom: 14,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors.gray4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon ?? const SizedBox(),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (title != null)
                      Text(
                        title ?? '',
                        style: STStyles.subtitle1,
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle ?? '',
                        style: STStyles.body1Semibold.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                  ],
                ),
              ),
              if (value != null) ...[
                Text(
                  value ?? '',
                  style: STStyles.body2Semibold.copyWith(
                    color: colors.gray10,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Assets.svg.medium.shevronRight.simpleSvg(
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
