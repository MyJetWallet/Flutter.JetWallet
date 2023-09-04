import 'package:flutter/material.dart';
import 'package:simple_kit/modules/indicators/step_indicator.dart';

import '../../simple_kit.dart';

class SVerificationHeader extends StatelessWidget {
  const SVerificationHeader({
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
  final int progressValue;
  final Function()? onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
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
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Baseline(
                          baseline: 24.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            title,
                            maxLines: 2,
                            style: sTextH5Style,
                          ),
                        ),
                      ],
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
              ],
            ),
          ),
          const Spacer(),
          const SpaceH24(),
          SStepIndicator(
            loadedPercent: progressValue,
          ),
        ],
      ),
    );
  }
}
