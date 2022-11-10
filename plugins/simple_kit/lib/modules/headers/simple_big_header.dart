import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';

class SBigHeader extends StatelessWidget {
  const SBigHeader({
    Key? key,
    this.customIconButton,
    this.onLinkTap,
    this.onSearchButtonTap,
    this.onBackButtonTap,
    this.onSupportButtonTap,
    this.linkText = '',
    this.showLink = false,
    this.showSearchButton = false,
    this.showSupportButton = false,
    required this.title,
  }) : super(key: key);

  final Widget? customIconButton;
  final Function()? onLinkTap;
  final Function()? onSearchButtonTap;
  final Function()? onSupportButtonTap;
  final String linkText;
  final bool showLink;
  final bool showSearchButton;
  final bool showSupportButton;
  final String title;
  final Function()? onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH64(),
          Row(
            children: [
              if (customIconButton != null)
                customIconButton!
              else
                SIconButton(
                  onTap: onBackButtonTap ?? () => Navigator.pop(context),
                  defaultIcon: const SBackIcon(),
                  pressedIcon: const SBackPressedIcon(),
                ),
              const Spacer(),
              if (showSearchButton)
                SIconButton(
                  onTap: onSearchButtonTap,
                  defaultIcon: const SSearchIcon(),
                  pressedIcon: const SSearchPressedIcon(),
                ),
              if (showSupportButton)
                SIconButton(
                  onTap: onSupportButtonTap,
                  defaultIcon: const SFaqIcon(),
                ),
            ],
          ),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(
                child: Baseline(
                  baseline: 56.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    title,
                    style: sTextH2Style,
                  ),
                ),
              ),
              if (showLink)
                Baseline(
                  baseline: 56.0,
                  baselineType: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: onLinkTap,
                    child: Text(
                      linkText,
                      style: sBodyText2Style.copyWith(
                        color: SColorsLight().blue,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
