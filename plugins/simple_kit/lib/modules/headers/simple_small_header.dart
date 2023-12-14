import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import 'package:simple_kit/simple_kit.dart';

class SSmallHeader extends StatelessWidget {
  const SSmallHeader({
    Key? key,
    this.icon,
    this.onStarButtonTap,
    this.onInfoButtonTap,
    this.onBackButtonTap,
    this.onCLoseButton,
    this.onEditButtonTap,
    this.onDoneButtonTap,
    this.onShareButtonTap,
    this.titleAlign = TextAlign.center,
    this.showBackButton = true,
    this.showStarButton = false,
    this.showInfoButton = false,
    this.showEditButton = false,
    this.showCloseButton = false,
    this.showDoneButton = false,
    this.isStarSelected = false,
    this.isShortVersion = false,
    this.showRCloseButton = false,
    this.showShareButton = false,
    required this.title,
    this.subTitle,
    this.subTitleStyle,
    this.titleStyle,
  }) : super(key: key);

  final Widget? icon;
  final Function()? onStarButtonTap;
  final Function()? onInfoButtonTap;
  final Function()? onBackButtonTap;
  final Function()? onEditButtonTap;
  final Function()? onDoneButtonTap;
  final Function()? onCLoseButton;
  final Function()? onShareButtonTap;
  final TextAlign titleAlign;
  final bool showBackButton;
  final bool showStarButton;
  final bool showInfoButton;
  final bool showEditButton;
  final bool showDoneButton;
  final bool showCloseButton;
  final bool isShortVersion;
  final bool showRCloseButton;
  final bool showShareButton;

  final bool isStarSelected;
  final String title;
  final TextStyle? titleStyle;

  final String? subTitle;
  final TextStyle? subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isShortVersion ? 88.0 : 120.0,
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
              else if (showRCloseButton)
                SIconButton(
                  onTap: onCLoseButton,
                  defaultIcon: const SCloseIcon(),
                  pressedIcon: const SClosePressedIcon(),
                )
              else
                const _IconPlaceholder(),
              const SpaceW12(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: titleAlign,
                      maxLines: 2,
                      style: titleStyle ?? sTextH5Style,
                    ),
                    if (subTitle != null) ...[
                      Text(
                        subTitle ?? '',
                        overflow: TextOverflow.ellipsis,
                        textAlign: titleAlign,
                        maxLines: 1,
                        style: subTitleStyle ?? sSubtitle3Style,
                      ),
                    ],
                  ],
                ),
              ),
              const SpaceW12(),
              if (showStarButton)
                SIconButton(
                  onTap: onStarButtonTap,
                  defaultIcon: isStarSelected ? const SStarSelectedIcon() : const SStarIcon(),
                  pressedIcon: const SStarPressedIcon(),
                )
              else if (showInfoButton)
                SIconButton(
                  onTap: onInfoButtonTap,
                  defaultIcon: const SInfoIcon(),
                  pressedIcon: const SInfoPressedIcon(),
                )
              else if (showEditButton)
                SIconButton(
                  onTap: onEditButtonTap,
                  defaultIcon: const SEditIcon(),
                  pressedIcon: const SEditIcon(),
                )
              else if (showDoneButton)
                SIconButton(
                  onTap: onDoneButtonTap,
                  defaultIcon: const SDoneIcon(),
                  pressedIcon: const SDoneIcon(),
                )
              else if (showCloseButton)
                SIconButton(
                  onTap: onCLoseButton,
                  defaultIcon: const SCloseIcon(),
                  pressedIcon: const SClosePressedIcon(),
                )
              else if (showShareButton)
                SIconButton(
                  onTap: onShareButtonTap,
                  defaultIcon: const SShareIcon(),
                  pressedIcon: SShareIcon(
                    color: SColorsLight().black.withOpacity(0.7),
                  ),
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
