import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/widgets/offer_tile.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
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
  void initState() {
    sAnalytics.chooseEarnPlanScreenView(assetName: widget.offers.first.assetId);
    if (widget.offers.isNotEmpty) {
      selectedOfferId = widget.offers.first.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Column(
      children: [
        const SizedBox(height: 32),
        SNetworkSvg(
          url: widget.currency.iconUrl,
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 16),
        Text(
          widget.currency.description,
          style: STStyles.header5.copyWith(color: colors.black),
        ),
        const SizedBox(height: 8),
        SPaddingH24(
          child: Text(
            intl.earn_choose_a_deposit_plan,
            style: STStyles.body1Medium.copyWith(color: colors.grey1),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.offers.map((offer) {
          return offer.status == EarnOfferStatus.activeShow
              ? OfferListItem(
                  offer: offer,
                  selectedOfferId: selectedOfferId,
                  onSelected: (value) {
                    setState(() {
                      selectedOfferId = value;
                    });
                  },
                )
              : const Offstage();
        }).toList(),
        const SizedBox(height: 48),
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
                    final selectedOffer = widget.offers.firstWhere((offer) => offer.id == selectedOfferId);
                    sAnalytics.tapOnTheContinueWithEarnPlanButton(
                      assetName: selectedOffer.assetId,
                      earnAPYrate: selectedOffer.apyRate?.toString() ?? Decimal.zero.toString(),
                      earnPlanName: selectedOffer.description ?? '',
                      earnWithdrawalType: selectedOffer.withdrawType.name,
                    );

                    context.router.push(
                      EarnDepositScreenRouter(offer: selectedOffer),
                    );
                  }
                : null,
          ),
        ),
      ],
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
