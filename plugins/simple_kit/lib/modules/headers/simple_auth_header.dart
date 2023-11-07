import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SLargeHeader extends StatelessWidget {
  const SLargeHeader({
    Key? key,
    this.customIconButton,
    this.onLinkTap,
    this.onSearchButtonTap,
    this.onBackButtonTap,
    this.onSupportButtonTap,
    this.progressValue = 0,
    this.linkText = '',
    this.showLink = false,
    this.showSearchButton = false,
    this.showSupportButton = false,
    this.isAutoSize = false,
    this.hideBackButton = false,
    this.maxLines = 1,
    required this.title,
    this.titleStyle,
  }) : super(key: key);

  final Widget? customIconButton;
  final Function()? onLinkTap;
  final Function()? onSearchButtonTap;
  final Function()? onSupportButtonTap;
  final String linkText;
  final bool showLink;
  final bool showSearchButton;
  final bool showSupportButton;
  final bool isAutoSize;
  final bool hideBackButton;
  final String title;
  final int progressValue;
  final int maxLines;
  final Function()? onBackButtonTap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SPaddingH24(
            child: Column(
              children: [
                const SpaceH60(),
                Row(
                  children: [
                    if (!hideBackButton) ...[
                      if (customIconButton != null)
                        customIconButton!
                      else
                        SIconButton(
                          onTap: onBackButtonTap ?? () => Navigator.pop(context),
                          defaultIcon: const SBackIcon(),
                          pressedIcon: const SBackPressedIcon(),
                        ),
                    ] else
                      const SizedBox(
                        height: 24,
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
                const SpaceH16(),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                      child: isAutoSize
                          ? AutoSizeText(
                              title,
                              textAlign: TextAlign.start,
                              minFontSize: 4.0,
                              maxLines: maxLines,
                              strutStyle: const StrutStyle(
                                height: 1.25,
                                fontSize: 32.0,
                                fontFamily: 'Gilroy',
                              ),
                              style: titleStyle ??
                                  TextStyle(
                                    height: 1.25,
                                    fontSize: 32.0,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                    color: SColorsLight().black,
                                  ),
                            )
                          : Text(
                              title,
                              maxLines: 2,
                              style: titleStyle ?? sTextH2Style,
                            ),
                    ),
                    if (showLink)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Baseline(
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
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
