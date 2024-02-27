import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/widgets/check_title.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class OfferListItem extends StatelessWidget {
  const OfferListItem({
    super.key,
    required this.offer,
    required this.selectedOfferId,
    required this.onSelected,
  });
  final EarnOfferClientModel offer;
  final String? selectedOfferId;
  final Function(String? value) onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return CheckTitle<String?>(
      radioValue: offer.id,
      radiogroupValue: selectedOfferId,
      title: offer.name ?? '',
      description: offer.description ?? '',
      onTap: () => onSelected(offer.id),
      rightValue: formatApyRate(offer.apyRate),
      badge: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: colors.grey5,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: offer.withdrawType == WithdrawType.instant
                    ? Assets.svg.medium.swap.simpleSvg()
                    : Assets.svg.medium.freeze.simpleSvg(),
              ),
              const SizedBox(width: 8),
              Text(
                offer.withdrawType == WithdrawType.instant
                    ? intl.earn_flexible_tariff
                    : intl.earn_freeze_period(offer.lockPeriod ?? ''),
                style: STStyles.captionSemibold,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatApyRate(Decimal? apyRate) {
    if (apyRate == null) {
      return 'N/A';
    } else {
      return '${(apyRate * Decimal.fromInt(100)).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}%';
    }
  }
}
