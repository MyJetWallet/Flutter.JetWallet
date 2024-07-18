import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class SBasicHeader extends StatelessWidget {
  const SBasicHeader({
    required this.title,
    this.subtitle,
    this.buttonTitle,
    this.onTap,
    this.showLinkButton = true,
    super.key,
    this.subtitleIcon,
  });

  final String title;
  final String? buttonTitle;
  final String? subtitle;
  final void Function()? onTap;
  final bool showLinkButton;
  final Widget? subtitleIcon;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null) ...[
            Text(
              title,
              style: sTextH4Style,
            ),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (subtitle != null) ...[
                Row(
                  children: [
                    Text(
                      subtitle!,
                      style: STStyles.body1Medium.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (subtitleIcon != null) subtitleIcon ?? const Offstage(),
                  ],
                ),
              ] else
                Text(
                  title,
                  style: sTextH4Style,
                ),
              if (onTap != null && buttonTitle != null) ...[
                const SizedBox(width: 8),
                if (showLinkButton)
                  GestureDetector(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        buttonTitle!,
                        style: STStyles.button.copyWith(color: colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
