// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showWalletVerifyAccount(
  BuildContext context, {
  required VoidCallback after,
  required bool isBanking,
}) {
  final kycState = getIt.get<KycService>();

  sShowAlertPopup(
    context,
    primaryText: '',
    secondaryText: intl.wallet_verify_your_account,
    primaryButtonName: intl.wallet_verify_account,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () async {
      sAnalytics.eurWalletTapOnVerifyAccount();

      if (kycState.requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
        await sRouter.push(
          SetPhoneNumberRouter(
            successText: intl.kycAlertHandler_factorVerificationEnabled,
            then: () => sRouter.push(
              KycVerifyYourProfileRouter(
                requiredVerifications: kycState.requiredVerifications,
                onFinish: after,
              ),
            ),
          ),
        );
      } else {
        await getIt<SumsubService>().launch(
          onFinish: after,
          isBanking: isBanking,
        );
      }

      Navigator.pop(context);
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
