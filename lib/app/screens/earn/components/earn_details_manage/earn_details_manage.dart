import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../shared/features/high_yield_buy/view/high_yield_buy.dart';
import '../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../shared/features/return_to_wallet/view/return_to_wallet.dart';
import '../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/earn_details_manage_item.dart';

void showEarnDetailsManage({
  required BuildContext context,
  required EarnOfferModel earnOffer,
  required String assetName,
}) {
  sAnalytics.earnManageView(
    assetName: assetName,
    amount: earnOffer.amount.toString(),
    apy: earnOffer.currentApy.toString(),
    term: earnOffer.term,
    offerId: earnOffer.offerId,
  );
  sShowBasicModalBottomSheet(
    context: context,
    onDissmis: () {
      sAnalytics.earnCloseManage(
        assetName: assetName,
        amount: earnOffer.amount.toString(),
        apy: earnOffer.currentApy.toString(),
        term: earnOffer.term,
        offerId: earnOffer.offerId,
      );
    },
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

class _EarnDetailsManageBottomSheetHeader extends HookWidget {
  const _EarnDetailsManageBottomSheetHeader({
    Key? key,
    required this.earnOffer,
    required this.assetName,
  }) : super(key: key);

  final String assetName;
  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

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
                  sAnalytics.earnCloseManage(
                    assetName: assetName,
                    amount: earnOffer.amount.toString(),
                    apy: earnOffer.currentApy.toString(),
                    term: earnOffer.term,
                    offerId: earnOffer.offerId,
                  );
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

class _EarnDetailsManage extends HookWidget {
  const _EarnDetailsManage({
    Key? key,
    required this.earnOffer,
  }) : super(key: key);

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final currency = currencyFrom(
      useProvider(currenciesPod),
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
                  sAnalytics.earnClickTopUp(
                    assetName: currency.description,
                    amount: earnOffer.amount.toString(),
                    apy: earnOffer.currentApy.toString(),
                    term: earnOffer.term,
                    offerId: earnOffer.offerId,
                  );
                  navigatorPushReplacement(
                    context,
                    HighYieldBuy(
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
                  sAnalytics.earnClickReclaim(
                    assetName: currency.description,
                    amount: earnOffer.amount.toString(),
                    apy: earnOffer.currentApy.toString(),
                    term: earnOffer.term,
                    offerId: earnOffer.offerId,
                  );
                  navigatorPushReplacement(
                    context,
                    ReturnToWallet(
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
