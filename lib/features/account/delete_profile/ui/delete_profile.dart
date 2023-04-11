import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/account/delete_profile/store/delete_profile_store.dart';
import 'package:jetwallet/features/account/delete_profile/ui/widgets/dp_checkbox.dart';
import 'package:jetwallet/features/account/delete_profile/ui/widgets/dp_condition_menu.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'DeleteProfileRouter')
class DeleteProfile extends StatelessObserverWidget {
  const DeleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final currencies = sSignalRModules.currenciesList;
    final itemsWithBalance = currenciesWithBalanceFrom(currencies);
    final baseCurrency = sSignalRModules.baseCurrency;

    final earnOffers = sSignalRModules.earnOffersList;

    final store = getIt.get<DeleteProfileStore>();

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
      loaderText: intl.register_pleaseWait,
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
              // Portfolio
              sRouter.navigate(
                const HomeRouter(
                  children: [
                    PortfolioRouter(),
                  ],
                ),
              );
            },
            isLinkActie: totalBalance > Decimal.ten,
          ),
          const SDivider(),
          DPConditionMenu(
            title: intl.deleteProfileConditions_menuTwoTitle,
            subTitle: intl.deleteProfileConditions_menuTwoSubTitle3,
            onTap: () {
              // Portfolio
              sRouter.navigate(
                const HomeRouter(
                  children: [
                    PortfolioRouter(),
                  ],
                ),
              );
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
                store.clickCheckbox();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: SPrimaryButton3(
              active: store.confitionCheckbox,
              name: intl.deleteProfileConditions_buttonText,
              onTap: () async {
                await sRouter.push(
                  const EmailConfirmationRouter(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
