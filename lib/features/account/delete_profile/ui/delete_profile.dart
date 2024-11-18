import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'DeleteProfileRouter')
class DeleteProfile extends StatelessObserverWidget {
  const DeleteProfile({
    required this.totalBalance,
    required this.simpleCoinBalance,
    super.key,
  });

  final Decimal totalBalance;
  final Decimal simpleCoinBalance;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final totalBalanceStr = totalBalance.toFormatSum(
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    );
    final simpleCoinBalanceText = simpleCoinBalance.toFormatCount(symbol: 'SMPL');

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: '',
        hasLeftIcon: false,
        onRightIconTap: () {
          sRouter.popUntilRouteWithName(ProfileDetailsRouter.name);
        },
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Center(
                child: Assets.svg.brand.small.error.simpleSvg(
                  height: 80.0,
                  width: 80.0,
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              Text(
                intl.deleteProfileConditions_funds_remaining,
                style: STStyles.header5.copyWith(
                  color: SColorsLight().black,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              if (totalBalance > Decimal.zero)
                Text(
                  intl.deleteProfileConditions_total_balance(totalBalanceStr),
                  style: STStyles.subtitle2.copyWith(
                    color: SColorsLight().gray10,
                  ),
                ),
              if (simpleCoinBalance > Decimal.zero)
                Text(
                  intl.deleteProfileConditions_total_coins(simpleCoinBalanceText),
                  style: STStyles.subtitle2.copyWith(
                    color: SColorsLight().gray10,
                  ),
                ),
              const SizedBox(
                height: 16.0,
              ),
              SHyperlink(
                text: intl.deleteProfileConditions_withdraw_or_transfer_funds,
                onTap: () {
                  sRouter.navigate(
                    const HomeRouter(
                      children: [
                        MyWalletsRouter(),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              SButton.black(
                text: intl.deleteProfileConditions_delete_anyway,
                callback: () {
                  sRouter.push(
                    const EmailConfirmationRouter(),
                  );
                },
              ),
              if (Platform.isAndroid)
                const SizedBox(
                  height: 24.0,
                ),
              SizedBox(
                height: 16.0 + MediaQuery.of(context).padding.bottom < 16.0 ? 8.0 : 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
