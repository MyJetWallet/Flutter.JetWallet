import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_kit/simple_kit.dart';

void showWalletVerifyAccount(
  BuildContext context, {
  required VoidCallback after,
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
    onPrimaryButtonTap: () {
      Navigator.pop(context);

      if (kycState.requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
        sRouter.push(
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
        sRouter.push(
          KycVerificationSumsubRouter(
            onFinish: after,
          ),
        );
      }
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}
