import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/main/simple_button.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class OffersOverlayContent extends StatefulWidget {
  const OffersOverlayContent({
    super.key,
    required this.offers,
    required this.currency,
  });
  final List<EarnOfferClientModel> offers;
  final CurrencyModel currency;

  @override
  _OffersOverlayContentState createState() => _OffersOverlayContentState();
}

class _OffersOverlayContentState extends State<OffersOverlayContent> {
  String? selectedOfferId;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colors.grey4,
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 36),
                  SNetworkSvg(
                    url: widget.currency.iconUrl,
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.currency.symbol,
                    style: STStyles.header5.copyWith(color: colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    intl.earn_choose_a_deposit_plan,
                    style: STStyles.body1Medium.copyWith(color: colors.grey1),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  ...widget.offers.map((offer) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ListTile(
                        selectedColor: colors.black,
                        title: Text(
                          offer.name ?? '',
                          style: STStyles.subtitle1,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (offer.description != null)
                              Text(
                                offer.description!,
                                style: STStyles.body1Medium.copyWith(color: colors.grey1),
                                maxLines: 2,
                              ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: colors.grey5,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (offer.withdrawType == WithdrawType.instant)
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: Assets.svg.medium.swap.simpleSvg(),
                                    )
                                  else
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: Assets.svg.medium.freeze.simpleSvg(),
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
                          ],
                        ),
                        trailing: Text(
                          formatApyRate(offer.apyRate),
                          style: STStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        leading: Transform.scale(
                          scale: 1.3,
                          child: Radio(
                            value: offer.id,
                            groupValue: selectedOfferId,
                            onChanged: (String? value) {
                              setState(() {
                                selectedOfferId = value;
                              });
                            },
                            activeColor: colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedOfferId = offer.id;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: SButton.blue(
              text: intl.earn_continue,
              callback: selectedOfferId != null
                  ? () {
                      //! Alex S. add routing
                      // context.router.push(const EarnDepositScreenRouter());
                      Navigator.pop(context);
                    }
                  : null,
            ),
          ),
        ],
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
