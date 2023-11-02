import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/20x20/public/checkmark/simple_checkmark_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/erase/simple_erase_market_icon.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

enum SBadgeStatus {
  primary,
  success,
  error,
}

class SBadge extends StatelessWidget {
  const SBadge({
    super.key,
    required this.status,
    required this.text,
    this.isLoading = false,
  });

  final SBadgeStatus status;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: getBGColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: getMainColor,
                  ),
                )
              : status == SBadgeStatus.error
                  ? SEraseMarketIcon(
                      color: getMainColor,
                    )
                  : SCheckmarkIcon(
                      color: getMainColor,
                    ),
          Text(
            text,
            style: sBodyText1Style.copyWith(
              height: 1,
              color: getMainColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Color get getBGColor {
    switch (status) {
      case SBadgeStatus.primary:
        return SColorsLight().blueExtraLight;
      case SBadgeStatus.success:
        return SColorsLight().greenExtraLight;
      case SBadgeStatus.error:
        return SColorsLight().redExtraLight;
      default:
        return SColorsLight().blueExtraLight;
    }
  }

  Color get getMainColor {
    switch (status) {
      case SBadgeStatus.primary:
        return SColorsLight().blue;
      case SBadgeStatus.success:
        return SColorsLight().green;
      case SBadgeStatus.error:
        return SColorsLight().red;
      default:
        return SColorsLight().blueExtraLight;
    }
  }
}
