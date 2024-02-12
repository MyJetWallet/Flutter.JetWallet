import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class SDepositCardBadge extends StatelessWidget {
  const SDepositCardBadge({
    super.key,
    required this.status,
    this.isLoading = false,
  });

  final EarnOfferStatus status;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
            style: sBodyText1Style.copyWith(
              height: 1,
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

  Color _getBGColor(EarnOfferStatus status, SColorsLight colors) {
    switch (status) {
      case EarnOfferStatus.activeShow:
      case EarnOfferStatus.activeHide:
        return colors.greenExtraLight;
      case EarnOfferStatus.closed:
        return colors.redExtraLight;
      default:
        return colors.grey5;
    }
  }

  Color _getMainColor(EarnOfferStatus status, SColorsLight colors) {
    switch (status) {
      case EarnOfferStatus.activeShow:
      case EarnOfferStatus.activeHide:
        return colors.green;
      case EarnOfferStatus.closed:
        return colors.red;
      default:
        return colors.grey1;
    }
  }

  String _getTextForStatus(EarnOfferStatus status) {
    switch (status) {
      case EarnOfferStatus.activeShow:
        return 'Earning';
      case EarnOfferStatus.activeHide:
        return 'Hidden';
      case EarnOfferStatus.closed:
        return 'Closed';
      default:
        return 'Unknown';
    }
  }
}
