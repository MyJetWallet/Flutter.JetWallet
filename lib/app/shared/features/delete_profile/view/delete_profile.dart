import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../helpers/formatting/base/market_format.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../earn/notifier/earn_offers_notipod.dart';
import '../../earn/provider/earn_offers_pod.dart';
import '../../email_confirmation/email_confirmation_screen.dart';
import '../notifier/delete_profile_notipod.dart';
import 'components/dp_checkbox.dart';
import 'components/dp_condition_menu.dart';

class DeleteProfile extends ConsumerWidget {
  const DeleteProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final intl = watch(intlPod);
    final colors = watch(sColorPod);

    final currencies = watch(currenciesPod);
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final baseCurrency = watch(baseCurrencyPod);
    final earnOffers = watch(earnOffersPod);
    final earnNotifier = watch(earnOffersNotipod.notifier);

    final state = watch(deleteProfileNotipod);
    final stateNotifier = watch(deleteProfileNotipod.notifier);

    final isEarnSubscriptionActive = earnNotifier.isActiveState(earnOffers);
    final earnSubscriptionLength = earnNotifier.getActiveLength(earnOffers);

    var earnTotalBalance = Decimal.zero;
    earnTotalBalance = earnOffers.fold(
      Decimal.zero,
      (previousValue, element) => previousValue + element.amount,
    );

    var totalBalance = Decimal.zero;
    for (final item in itemsWithBalance) {
      totalBalance += item.baseBalance;
    }
    final totalBalanceStr = marketFormat(
      prefix: baseCurrency.prefix,
      decimal: totalBalance,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    );

    return SPageFrame(
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.deleteProfileConditions_title,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SPaddingH24(
            child: Text(
              intl.deleteProfileConditions_subTitle,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          const SizedBox(
            height: 31,
          ),
          DPConditionMenu(
            title: intl.deleteProfileConditions_menuOneTitle,
            subTitle: '${intl.deleteProfileConditions_menuOneSubTitle}'
                '$totalBalanceStr',
            onTap: () {
              watch(navigationStpod).state = 1; // Portfolio
              navigateToRouter(watch);
            },
            isLinkActie: totalBalance > Decimal.ten,
          ),
          const SDivider(),
          DPConditionMenu(
            title: intl.deleteProfileConditions_menuTwoTitle,
            subTitle: isEarnSubscriptionActive
                ? '${intl.deleteProfileConditions_menuTwoSubTitle}'
                    '$earnSubscriptionLength '
                    '${intl.deleteProfileConditions_menuTwoSubTitle2}'
                : intl.deleteProfileConditions_menuTwoSubTitle3,
            onTap: () {
              watch(navigationStpod).state = 2; // Portfolio
              navigateToRouter(watch);
            },
            isLinkActie: earnTotalBalance > Decimal.ten,
          ),
          const SizedBox(
            height: 23,
          ),
          SPaddingH24(
            child: Text(
              intl.deleteProfileConditions_warning,
              textAlign: TextAlign.start,
              maxLines: 8,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: DPCheckbox(
              text: intl.deleteProfileConditions_conditions,
              onCheckboxTap: () {
                stateNotifier.clickCheckbox();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: SPrimaryButton3(
              active: totalBalance <= Decimal.ten &&
                  earnTotalBalance <= Decimal.ten &&
                  state.confitionCheckbox,
              name: intl.deleteProfileConditions_buttonText,
              onTap: () async {
                navigatorPush(context, const EmailConfirmationScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}
