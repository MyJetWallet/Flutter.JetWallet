import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_buy/widgets/buy_payment_currency.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

void showStartEarnOptions({
  required CurrencyModel currency,
}) {
  final context = sRouter.navigatorKey.currentContext!;
  final kycState = getIt.get<KycService>();
  final kycAlertHandler = getIt.get<KycAlertHandler>();

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
            Navigator.pop(context);

            showBuyPaymentCurrencyBottomSheet(context, currency);
          } else {
            Navigator.of(context).pop();

            kycAlertHandler.handle(
              status: kycState.depositStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () {
                Navigator.pop(context);
                showBuyPaymentCurrencyBottomSheet(context, currency);
              },
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        icon: const SActionBuyIcon(),
        name: '${intl.showStartEarnOptions_buy} ${currency.description}',
        description: intl.showStartEarnOptions_buyAnyCryptoAvailableOnThePlatform,
      ),
      SActionItem(
        onTap: () {
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            Navigator.pop(context);
            sRouter.push(
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
              currentNavigate: () {
                Navigator.pop(context);
                sRouter.push(
                  CryptoDepositRouter(
                    header: intl.showStartEarnOptions_receive,
                    currency: currency,
                  ),
                );
              },
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
  const _EarnStartPinned();

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
