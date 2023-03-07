import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'components/earn_details_manage_item.dart';

void showEarnDetailsManage({
  required BuildContext context,
  required EarnOfferModel earnOffer,
  required String assetName,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    onDissmis: () {},
    scrollable: true,
    pinned: _EarnDetailsManageBottomSheetHeader(
      assetName: assetName,
      earnOffer: earnOffer,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _EarnDetailsManage(earnOffer: earnOffer),
    ],
  );
}

class _EarnDetailsManageBottomSheetHeader extends StatelessWidget {
  const _EarnDetailsManageBottomSheetHeader({
    Key? key,
    required this.earnOffer,
    required this.assetName,
  }) : super(key: key);

  final String assetName;
  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SPaddingH24(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 20.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  intl.earn_manage,
                  style: sTextH4Style,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const SErasePressedIcon(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EarnDetailsManage extends StatelessObserverWidget {
  const _EarnDetailsManage({
    Key? key,
    required this.earnOffer,
  }) : super(key: key);

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      earnOffer.asset,
    );

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH24(),
            if (earnOffer.topUpEnabled)
              EarnDetailsManageItem(
                primaryText: intl.earn_top_up,
                onTap: () {
                  Navigator.of(context).pop();

                  Navigator.pop(context);
                  sRouter.push(
                    HighYieldBuyRouter(
                      currency: currency,
                      earnOffer: earnOffer,
                      topUp: true,
                    ),
                  );
                },
                icon: const STopUpIcon(),
                color: colors.grey5,
              ),
            if (earnOffer.withdrawalEnabled && earnOffer.topUpEnabled)
              const SPaddingH24(child: SDivider()),
            if (earnOffer.withdrawalEnabled)
              EarnDetailsManageItem(
                primaryText: intl.earn_return_to_wallet,
                onTap: () {
                  Navigator.of(context).pop();

                  Navigator.pop(context);
                  sRouter.push(
                    ReturnToWalletRouter(
                      currency: currency,
                      earnOffer: earnOffer,
                    ),
                  );
                },
                icon: const SForwardIcon(),
                color: colors.grey5,
              ),
            const SpaceH24(),
          ],
        ),
      ],
    );
  }
}
