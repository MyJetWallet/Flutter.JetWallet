import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/delete_profile/view/components/dp_checkbox.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/currencies_with_balance_from.dart';
import '../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../screens/market/provider/market_crypto_pod.dart';
import '../../../../screens/market/provider/market_fiats_pod.dart';
import '../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../helpers/formatting/base/market_format.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
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
      child: SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              intl.deleteProfileConditions_subTitle,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
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
              isLinkActie: totalBalance != Decimal.zero,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SDivider(),
            ),
            DPConditionMenu(
              title: intl.deleteProfileConditions_menuTwoTitle,
              subTitle: intl.deleteProfileConditions_menuTwoSubTitle,
              onTap: () {
                watch(navigationStpod).state = 2; // Portfolio
                navigateToRouter(watch);
              },
              isLinkActie: true,
            ),
            const SizedBox(
              height: 39,
            ),
            Text(
              intl.deleteProfileConditions_warning,
              textAlign: TextAlign.start,
              maxLines: 8,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
            const Spacer(),
            DPCheckbox(
              text: intl.deleteProfileConditions_conditions,
              onCheckboxTap: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SPrimaryButton3(
                active: true,
                name: intl.deleteProfileConditions_buttonText,
                onTap: () async {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
