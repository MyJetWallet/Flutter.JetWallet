import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/20x20/public/checkmark/simple_checkmark_icon.dart';
import 'package:simple_kit/modules/icons/20x20/public/deposit_in_progress/simple_clock_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/erase/simple_erase_market_icon.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

enum SBadgeStatus {
  primary,
  success,
  error,
  pending,
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
              ? Padding(
                padding: const EdgeInsets.only(left: 2),
                child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: getMainColor,
                    ),
                  ),
              )
              : status == SBadgeStatus.error
                  ? SEraseMarketIcon(
                      color: getMainColor,
                    )
                  : status == SBadgeStatus.pending
                      ? SClockIcon(
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
      case SBadgeStatus.pending:
        return SColorsLight().grey5;
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
      case SBadgeStatus.pending:
        return SColorsLight().grey1;
      case SBadgeStatus.success:
        return SColorsLight().green;
      case SBadgeStatus.error:
        return SColorsLight().red;
      default:
        return SColorsLight().blueExtraLight;
    }
  }
}
