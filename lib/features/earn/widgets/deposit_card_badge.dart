import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

class SDepositCardBadge extends StatelessWidget {
  const SDepositCardBadge({
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
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: _getBGColor(status, colors),
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
                color: _getMainColor(status, colors),
              ),
            )
          else
            _buildDot(color: _getMainColor(status, colors)),
          const SizedBox(width: 4),
          Text(
            _getTextForStatus(status),
            style: STStyles.captionMedium.copyWith(
              color: _getMainColor(status, colors),
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

  Color _getBGColor(EarnPositionStatus status, SColorsLight colors) {
    switch (status) {
      case EarnPositionStatus.active:
        return colors.greenExtralight;
      case EarnPositionStatus.closing:
        return colors.blueExtralight;
      case EarnPositionStatus.closed:
        return colors.gray2;
      default:
        return colors.gray2;
    }
  }

  Color _getMainColor(EarnPositionStatus status, SColorsLight colors) {
    switch (status) {
      case EarnPositionStatus.active:
        return colors.green;
      case EarnPositionStatus.closing:
        return colors.blue;
      case EarnPositionStatus.closed:
        return colors.gray10;
      default:
        return colors.gray10;
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
