import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showStartEarnOptions({
  required CurrencyModel currency,
}) {
  final context = sRouter.navigatorKey.currentContext!;
  final kycState = getIt.get<KycService>();
  final kycAlertHandler = getIt.get<KycAlertHandler>();

  final balancesEmpty = areBalancesEmpty(sCurrencies.currencies);

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

            sRouter.replace(
              CurrencyBuyRouter(
                currency: currency,
                fromCard: balancesEmpty,
              ),
            );
          } else {
            Navigator.of(context).pop();

            kycAlertHandler.handle(
              status: kycState.depositStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () {
                sAnalytics.buyView(
                  Source.earnProgram,
                  currency.description,
                );
                sAnalytics.earnDetailsView(currency.description);

                sRouter.replace(
                  CurrencyBuyRouter(
                    currency: currency,
                    fromCard: balancesEmpty,
                  ),
                );
              },
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
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
            sAnalytics.receiveAssetView(asset: currency.description);

            sRouter.replace(
              CryptoDepositRouter(
                header: intl.showStartEarnOptions_receive,
                currency: currency,
              ),
            );
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.depositStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => sRouter.replace(
                CryptoDepositRouter(
                  header: intl.showStartEarnOptions_receive,
                  currency: currency,
                ),
              ),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
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

class _EarnStartPinned extends StatelessWidget {
  const _EarnStartPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
