import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/widgets/offer_tile.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class OffersOverlayContent extends StatefulWidget {
  const OffersOverlayContent({
    super.key,
    required this.offers,
    required this.currency,
    required this.setParentOnTap,
  });

  final List<EarnOfferClientModel> offers;
  final CurrencyModel currency;
  final Function(VoidCallback)? setParentOnTap;

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
    if (selectedOfferId != null) {
      void onTapInContent() {
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

      widget.setParentOnTap?.call(onTapInContent);
    }

    final colors = SColorsLight();

    return Column(
      children: [
        const SizedBox(height: 32),
        NetworkIconWidget(
          widget.currency.iconUrl,
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
        }),
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
