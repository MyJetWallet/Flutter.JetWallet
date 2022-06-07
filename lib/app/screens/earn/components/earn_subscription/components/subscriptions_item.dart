import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import '../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/high_yield_buy/view/high_yield_buy.dart';
import '../../../../../shared/features/kyc/model/kyc_operation_status_model.dart';
import '../../../../../shared/features/kyc/notifier/kyc/kyc_notipod.dart';
import '../../../../../shared/models/currency_model.dart';

class SubscriptionsItem extends HookWidget {
  const SubscriptionsItem({
    Key? key,
    this.days = 0,
    required this.isHot,
    required this.earnOffer,
    required this.currency,
  }) : super(key: key);

  final bool isHot;
  final int days;
  final EarnOfferModel earnOffer;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);
    final kyc = context.read(kycNotipod);
    final handler = context.read(kycAlertHandlerPod(context));
    var apy = Decimal.zero;

    for (final element in earnOffer.tiers) {
      if (element.apy > apy) {
        apy = element.apy;
      }
    }

    return Column(
      children: [
        InkWell(
          highlightColor: colors.grey5,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            if (kyc.depositStatus == kycOperationStatus(KycStatus.allowed)) {
              navigatorPushReplacement(
                context,
                HighYieldBuy(
                  currency: currency,
                  earnOffer: earnOffer,
                ),
              );
            } else {
              handler.handle(
                status: kyc.depositStatus,
                kycVerified: kyc,
                isProgress: kyc.verificationInProgress,
                currentNavigate: () => SubscriptionsItem(
                  days: days,
                  isHot: isHot,
                  earnOffer: earnOffer,
                  currency: currency,
                ),
              );
            }
          },
          child: Ink(
            height: 88,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: colors.grey4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isHot
                              ? '${intl.earn_hot} ${String.fromCharCodes(
                                  Runes('\u{1F525}'),
                                )}'
                              : intl.earn_flexible,
                          style: sSubtitle2Style.copyWith(
                            color: colors.black,
                          ),
                        ),
                        if (days > 0)
                          Text(
                            '$days ${days == 1
                                ? intl.earn_day_remaining
                                : intl.earn_days_remaining}',
                            style: sBodyText2Style.copyWith(
                              color: colors.grey2,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '$apy%',
                      style: sTextH2Style.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SpaceH10(),
      ],
    );
  }
}
