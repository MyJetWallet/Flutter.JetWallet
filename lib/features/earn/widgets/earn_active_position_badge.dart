import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/modules/icons/20x20/public/checkmark/simple_checkmark_icon.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

class SEarnPositionBadge extends StatelessWidget {
  const SEarnPositionBadge({
    super.key,
    required this.status,
  });

  final EarnPositionStatus status;

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
          _getIcon(status, _getMainColor(status, colors)),
          Text(
            getTextForStatus(status),
            style: STStyles.body1Medium.copyWith(
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
        return Assets.svg.medium.checkmarkAlt.simpleSvg(
          color: color,
          width: 20,
        );
      case EarnPositionStatus.closing:
        return Assets.svg.medium.timer.simpleSvg(
          color: color,
          width: 20,
        );
      case EarnPositionStatus.closed:
        return Assets.svg.medium.checkmarkAlt.simpleSvg(
          color: color,
          width: 20,
        );
      default:
        return SCheckmarkIcon(color: color);
    }
  }

  Color _getBGColor(EarnPositionStatus status, SColorsLight colors) {
    switch (status) {
      case EarnPositionStatus.active:
        return colors.greenExtralight;
      case EarnPositionStatus.closing:
        return colors.blueExtralight;
      case EarnPositionStatus.closed:
        return SColorsLight().gray2;
      default:
        return SColorsLight().gray2;
    }
  }

  Color _getMainColor(EarnPositionStatus status, SColorsLight colors) {
    switch (status) {
      case EarnPositionStatus.active:
        return colors.green;
      case EarnPositionStatus.closing:
        return colors.blue;
      case EarnPositionStatus.closed:
        return SColorsLight().gray8;
      default:
        return SColorsLight().gray10;
    }
  }
}

String getTextForStatus(EarnPositionStatus status) {
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

/// we use this method for analytic
String getTextForStatusAnalytics(EarnPositionStatus status) {
  switch (status) {
    case EarnPositionStatus.active:
      return 'Earning';
    case EarnPositionStatus.closing:
      return 'Closing';
    case EarnPositionStatus.closed:
      return 'Finished';
    default:
      return intl.earn_unknown;
  }
}
