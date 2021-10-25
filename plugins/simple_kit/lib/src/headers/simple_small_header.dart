import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

class SSmallHeader extends StatelessWidget {
  const SSmallHeader({
    Key? key,
    this.onStarButtonTap,
    this.onBackButtonTap,
    this.showBackButton = true,
    this.showStarButton = false,
    this.isStarSelected = false,
    required this.title,
  }) : super(key: key);

  final Function()? onStarButtonTap;
  final Function()? onBackButtonTap;
  final bool showBackButton;
  final bool showStarButton;
  final bool isStarSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: Column(
        children: [
          SizedBox(
            height: 64.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBackButton)
                SIconButton(
                  onTap: onBackButtonTap,
                  defaultIcon: const SBackIcon(),
                  pressedIcon: const SBackPressedIcon(),
                )
              else
                const _IconPlaceholder(),
              STextH5(
                text: title,
              ),
              if (showStarButton)
                SIconButton(
                  onTap: onStarButtonTap,
                  defaultIcon: isStarSelected
                      ? const SStarSelectedIcon()
                      : const SStarIcon(),
                  pressedIcon: const SStarPressedIcon(),
                )
              else
                const _IconPlaceholder()
            ],
          )
        ],
      ),
    );
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w,
      height: 24.h,
    );
  }
}
