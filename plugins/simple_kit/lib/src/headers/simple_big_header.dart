import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SBigHeader extends StatelessWidget {
  const SBigHeader({
    Key? key,
    this.onLinkTap,
    this.onSearchButtonTap,
    this.onBackButtonTap,
    this.linkText = '',
    this.showLink = false,
    this.showSearchButton = false,
    required this.title,
  }) : super(key: key);

  final Function()? onLinkTap;
  final Function()? onSearchButtonTap;
  final String linkText;
  final bool showLink;
  final bool showSearchButton;
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
            ],
          ),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Baseline(
                baseline: 56.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  title,
                  style: sTextH2Style,
                ),
              ),
              const Spacer(),
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
