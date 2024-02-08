import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

enum SDepositCardBadgeStatus {
  primary,
  success,
  error,
  pending,
}

class SDepositCardBadge extends StatelessWidget {
  const SDepositCardBadge({
    super.key,
    required this.status,
    required this.text,
    this.isLoading = false,
  });

  final SDepositCardBadgeStatus status;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: getBGColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLoading)
            SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: getMainColor,
              ),
            )
          else
            status == SDepositCardBadgeStatus.error
                ? _buildDot(
                    color: getMainColor,
                  )
                : status == SDepositCardBadgeStatus.pending
                    ? _buildDot(
                        color: getMainColor,
                      )
                    : _buildDot(
                        color: getMainColor,
                      ),
          const SizedBox(width: 4),
          Text(
            text,
            style: sBodyText1Style.copyWith(
              height: 1,
              color: getMainColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required Color color}) {
    return Container(
      height: 6.0,
      width: 6.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Color get getBGColor {
    switch (status) {
      case SDepositCardBadgeStatus.primary:
        return SColorsLight().blueExtraLight;
      case SDepositCardBadgeStatus.pending:
        return SColorsLight().grey5;
      case SDepositCardBadgeStatus.success:
        return SColorsLight().greenExtraLight;
      case SDepositCardBadgeStatus.error:
        return SColorsLight().redExtraLight;
      default:
        return SColorsLight().blueExtraLight;
    }
  }

  Color get getMainColor {
    switch (status) {
      case SDepositCardBadgeStatus.primary:
        return SColorsLight().blue;
      case SDepositCardBadgeStatus.pending:
        return SColorsLight().grey1;
      case SDepositCardBadgeStatus.success:
        return SColorsLight().green;
      case SDepositCardBadgeStatus.error:
        return SColorsLight().red;
      default:
        return SColorsLight().blueExtraLight;
    }
  }
}
