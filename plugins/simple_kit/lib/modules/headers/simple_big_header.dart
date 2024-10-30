import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SBigHeader extends StatelessWidget {
  const SBigHeader({
    super.key,
    this.customIconButton,
    this.onLinkTap,
    this.onSearchButtonTap,
    this.onBackButtonTap,
    this.onSupportButtonTap,
    this.linkText = '',
    this.showLink = false,
    this.showSearchButton = false,
    this.showSupportButton = false,
    this.isSmallSize = false,
    required this.title,
  });

  final Widget? customIconButton;
  final Function()? onLinkTap;
  final Function()? onSearchButtonTap;
  final Function()? onSupportButtonTap;
  final String linkText;
  final bool showLink;
  final bool showSearchButton;
  final bool showSupportButton;
  final bool isSmallSize;
  final String title;
  final Function()? onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isSmallSize ? 150.0 : 180.0,
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
          if (isSmallSize) const SpaceH6(),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(
                child: Baseline(
                  baseline: isSmallSize ? 40.0 : 56.0,
                  baselineType: TextBaseline.alphabetic,
                  child: AutoSizeText(
                    title,
                    minFontSize: 16.0,
                    maxLines: 1,
                    strutStyle: const StrutStyle(
                      height: 1.25,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                    ),
                    style: const TextStyle(
                      height: 1.25,
                      fontSize: 32.0,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
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
