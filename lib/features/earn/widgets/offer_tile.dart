import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
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

    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 32,
        left: 16,
        right: 24,
      ),
      child: InkWell(
        onTap: () => onSelected(offer.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(0, -10),
              child: Radio(
                value: offer.id,
                groupValue: selectedOfferId,
                onChanged: onSelected,
                activeColor: colors.black,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.name ?? '',
                    style: STStyles.subtitle1,
                  ),
                  if (offer.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        offer.description!,
                        style: STStyles.body1Medium.copyWith(color: colors.grey1),
                        maxLines: 2,
                      ),
                    ),
                  Padding(
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                formatApyRate(offer.apyRate),
                style: STStyles.subtitle1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatApyRate(Decimal? apyRate) {
    if (apyRate == null) {
      return 'N/A';
    } else {
      return '${(apyRate * Decimal.fromInt(100)).toStringAsFixed(2)}%';
    }
  }
}
