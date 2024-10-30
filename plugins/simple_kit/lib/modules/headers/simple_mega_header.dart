import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SMegaHeader extends StatelessWidget {
  const SMegaHeader({
    super.key,
    this.onBackButtonTap,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.titleAlign = TextAlign.center,
    this.showBackButton = true,
    this.rightIcon,
    required this.title,
  });

  final Function()? onBackButtonTap;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign titleAlign;
  final String title;
  final bool showBackButton;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 180.0,
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          const SpaceH64(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBackButton)
                SIconButton(
                  onTap: onBackButtonTap ?? () => Navigator.pop(context),
                  defaultIcon: const SBackIcon(),
                  pressedIcon: const SBackPressedIcon(),
                ),
              if (!showBackButton)
                const SizedBox(
                  height: 24,
                  width: 24,
                ),
              if (rightIcon != null) ...[
                rightIcon!,
              ],
            ],
          ),
          Baseline(
            baseline: 56.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              title,
              textAlign: titleAlign,
              maxLines: 3,
              style: sTextH2Style,
            ),
          ),
          const SpaceH28(),
        ],
      ),
    );
  }
}
