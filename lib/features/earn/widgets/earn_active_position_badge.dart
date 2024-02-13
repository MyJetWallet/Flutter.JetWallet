import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/20x20/public/checkmark/simple_checkmark_icon.dart';
import 'package:simple_kit/modules/icons/20x20/public/deposit_in_progress/simple_clock_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/erase/simple_erase_market_icon.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

class SEarnPositionBadge extends StatelessWidget {
  const SEarnPositionBadge({
    super.key,
    required this.status,
    this.isLoading = false,
  });

  final EarnPositionStatus status;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: _getBGColor(status, colors),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLoading)
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _getMainColor(status, colors),
              ),
            )
          else
            _getIcon(status, _getMainColor(status, colors)),
          Text(
            _getTextForStatus(status),
            style: sBodyText1Style.copyWith(
              height: 1,
              color: _getMainColor(status, colors),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _getIcon(EarnPositionStatus status, Color color) {
    switch (status) {
      case EarnPositionStatus.active:
        return SCheckmarkIcon(color: color);
      case EarnPositionStatus.closing:
        return SClockIcon(color: color);
      case EarnPositionStatus.closed:
        return SEraseMarketIcon(color: color);
      default:
        return SCheckmarkIcon(color: color);
    }
  }

  Color _getBGColor(EarnPositionStatus status, SColorsLight colors) {
    switch (status) {
      case EarnPositionStatus.active:
        return colors.greenExtraLight;
      case EarnPositionStatus.closing:
        return colors.blueExtraLight;
      case EarnPositionStatus.closed:
        return colors.redExtraLight;
      default:
        return colors.grey5;
    }
  }

  Color _getMainColor(EarnPositionStatus status, SColorsLight colors) {
    switch (status) {
      case EarnPositionStatus.active:
        return colors.green;
      case EarnPositionStatus.closing:
        return colors.blue;
      case EarnPositionStatus.closed:
        return colors.red;
      default:
        return colors.grey1;
    }
  }

  String _getTextForStatus(EarnPositionStatus status) {
    switch (status) {
      case EarnPositionStatus.active:
        return intl.earn_earning;
      case EarnPositionStatus.closing:
        return intl.earn_closing;
      case EarnPositionStatus.closed:
        return intl.earn_closed;
      default:
        return intl.earn_unknown;
    }
  }
}
