import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

class SBigHeader extends StatelessWidget {
  const SBigHeader({
    Key? key,
    this.onLinkTap,
    this.onSearchButtonTap,
    this.linkText = '',
    this.showLink = false,
    this.showSearchButton = false,
    required this.title,
    required this.onBackButtonTap,
  }) : super(key: key);

  final Function()? onLinkTap;
  final Function()? onSearchButtonTap;
  final String linkText;
  final bool showLink;
  final bool showSearchButton;
  final String title;
  final Function() onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 64.h,
          ),
          Row(
            children: [
              SIconButton(
                onTap: onBackButtonTap,
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
          SizedBox(
            height: 56.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                STextH2(
                  text: title,
                ),
                const Spacer(),
                if (showLink)
                  GestureDetector(
                    onTap: onLinkTap,
                    child: SBodyText2(
                      text: linkText,
                      color: SColorsLight().blue,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
