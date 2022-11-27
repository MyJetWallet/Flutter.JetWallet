import 'package:flutter/material.dart';

import 'package:simple_kit/simple_kit.dart';

class SSmallHeader extends StatelessWidget {
  const SSmallHeader({
    Key? key,
    this.icon,
    this.onStarButtonTap,
    this.onInfoButtonTap,
    this.onBackButtonTap,
    this.titleAlign = TextAlign.center,
    this.showBackButton = true,
    this.showStarButton = false,
    this.showInfoButton = false,
    this.isStarSelected = false,
    required this.title,
  }) : super(key: key);

  final Widget? icon;
  final Function()? onStarButtonTap;
  final Function()? onInfoButtonTap;
  final Function()? onBackButtonTap;
  final TextAlign titleAlign;
  final bool showBackButton;
  final bool showStarButton;
  final bool showInfoButton;
  final bool isStarSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.0,
      child: Column(
        children: [
          const SpaceH64(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBackButton)
                SIconButton(
                  onTap: onBackButtonTap ?? () => Navigator.pop(context),
                  defaultIcon: icon != null ? icon! : const SBackIcon(),
                  pressedIcon: icon != null ? icon! : const SBackPressedIcon(),
                )
              else
                const _IconPlaceholder(),
              const SpaceW12(),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: titleAlign,
                  maxLines: 1,
                  style: sTextH5Style,
                ),
              ),
              const SpaceW12(),
              if (showStarButton)
                SIconButton(
                  onTap: onStarButtonTap,
                  defaultIcon: isStarSelected
                      ? const SStarSelectedIcon()
                      : const SStarIcon(),
                  pressedIcon: const SStarPressedIcon(),
                )
              else if (showInfoButton)
                SIconButton(
                  onTap: onInfoButtonTap,
                  defaultIcon: const SInfoIcon(),
                  pressedIcon: const SInfoPressedIcon(),
                )
              else
                const _IconPlaceholder(),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24.0,
      height: 24.0,
    );
  }
}
