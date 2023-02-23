import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/indicators/step_indicator.dart';

import '../../simple_kit.dart';

class SAuthHeader extends StatelessWidget {
  const SAuthHeader({
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
    this.maxLines = 1,
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
  final bool isAutoSize;
  final String title;
  final int progressValue;
  final int maxLines;
  final Function()? onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SPaddingH24(
            child: Column(
              children: [
                const SpaceH60(),
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
                                style: TextStyle(
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
                                style: sTextH2Style,
                              ),
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
