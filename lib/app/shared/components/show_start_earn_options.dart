import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  final intl = context.read(intlPod);

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
        name: '${intl.showStartEarnOptions_buy} ${currency.description}',
        description:
            intl.showStartEarnOptions_buyAnyCryptoAvailableOnThePlatform,
      ),
      SActionItem(
        onTap: () {
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            sAnalytics.depositCryptoView(currency.description);
            navigatorPushReplacement(
              context,
              CryptoDeposit(
                header: intl.showStartEarnOptions_receive,
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
                  header: intl.showStartEarnOptions_receive,
                  currency: currency,
                ),
              ),
            );
          }
        },
        icon: const SActionDepositIcon(),
        name: '${intl.showStartEarnOptions_receive} ${currency.description}',
        description: intl.showStartEarnOptions_depositCryptoFromAnotherWallet,
      ),
      const SpaceH40(),
    ],
  );
}

class _EarnStartPinned extends HookWidget {
  const _EarnStartPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Row(
      children: [
        Expanded(
          child: Text(
            intl.showStartEarnOptions_startEarn,
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
