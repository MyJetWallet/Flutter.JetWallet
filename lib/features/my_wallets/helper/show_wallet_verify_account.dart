// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/get_kuc_aid_plan.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/start_kyc_aid_flow.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

void showWalletVerifyAccount(
  BuildContext context, {
  required Function() after,
  required bool isBanking,
}) {
  final kycState = getIt.get<KycService>();

  var isClick = false;

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
      if (isClick) return;

      sAnalytics.eurWalletTapOnVerifyAccount();

      Future.delayed(const Duration(seconds: 1), () {
        isClick = false;
      });

      isClick = true;

      Navigator.pop(context);

      getIt.get<GlobalLoader>().setLoading(true);

      if (kycState.requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
        getIt.get<GlobalLoader>().setLoading(false);
        await sRouter.push(
          SetPhoneNumberRouter(
            successText: intl.kycAlertHandler_factorVerificationEnabled,
            then: () async {
              sRouter.popUntilRoot();

              await _launchKycFlow(
                after: after,
                isBanking: isBanking,
              );
            },
          ),
        );
      } else {
        getIt.get<GlobalLoader>().setLoading(false);
        await _launchKycFlow(
          after: after,
          isBanking: isBanking,
        );
      }
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      Navigator.pop(context);
    },
  );
}

Future<void> _launchKycFlow({
  required Function() after,
  required bool isBanking,
}) async {
  final kycPlan = await getKYCAidPlan();

  if (kycPlan == null) return;

  if (kycPlan.provider == KycProvider.sumsub) {
    await getIt<SumsubService>().launch(
      onFinish: after,
      isBanking: isBanking,
      needPush: false,
    );
  } else if (kycPlan.provider == KycProvider.kycAid) {
    await startKycAidFlow(kycPlan);
  }
}
