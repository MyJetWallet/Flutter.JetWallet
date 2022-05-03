import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/navigator_push_replacement.dart';
import '../../../shared/providers/service_providers.dart';
import '../features/crypto_deposit/view/crypto_deposit.dart';
import '../features/currency_buy/view/curency_buy.dart';
import '../features/kyc/model/kyc_operation_status_model.dart';
import '../features/kyc/notifier/kyc/kyc_notipod.dart';
import '../helpers/are_balances_empty.dart';
import '../models/currency_model.dart';
import '../providers/currencies_pod/currencies_pod.dart';

void showStartEarnOptions({
  required CurrencyModel currency,
  required Reader read,
}) {
  final context = read(sNavigatorKeyPod).currentContext!;
  final kycState = read(kycNotipod);
  final kycAlertHandler = read(
    kycAlertHandlerPod(context),
  );
  final balancesEmpty = areBalancesEmpty(read(currenciesPod));

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _EarnStartPinned(),
    removePinnedPadding: true,
    children: [
      const SpaceH24(),
      SActionItem(
        onTap: () {
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            sAnalytics.buyView(
              Source.earnProgram,
              currency.description,
            );
            sAnalytics.earnDetailsView(currency.description);

            navigatorPushReplacement(
              context,
              CurrencyBuy(
                currency: currency,
                fromCard: balancesEmpty,
              ),
            );
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.depositStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () {
                sAnalytics.buyView(
                  Source.earnProgram,
                  currency.description,
                );
                sAnalytics.earnDetailsView(currency.description);
                navigatorPushReplacement(
                  context,
                  CurrencyBuy(
                    currency: currency,
                    fromCard: balancesEmpty,
                  ),
                );
              },
            );
          }
        },
        icon: const SActionBuyIcon(),
        name: 'Buy ${currency.description}',
        description: 'Buy any crypto available on the platform',
      ),
      SActionItem(
        onTap: () {
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            sAnalytics.depositCryptoView(currency.description);
            navigatorPushReplacement(
              context,
              CryptoDeposit(
                header: 'Receive',
                currency: currency,
              ),
            );
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.depositStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => navigatorPushReplacement(
                context,
                CryptoDeposit(
                  header: 'Receive',
                  currency: currency,
                ),
              ),
            );
          }
        },
        icon: const SActionDepositIcon(),
        name: 'Receive ${currency.description}',
        description: 'Deposit crypto from another wallet',
      ),
      const SpaceH40(),
    ],
  );
}

class _EarnStartPinned extends StatelessWidget {
  const _EarnStartPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Start earning',
            style: sTextH4Style,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const SEraseIcon(),
        ),
      ],
    );
  }
}
