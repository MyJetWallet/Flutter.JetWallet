import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/get_kuc_aid_plan.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/start_kyc_aid_flow.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

import '../../../app/store/global_loader.dart';

void showCompleteVerificationAccount(
  BuildContext context,
  VoidCallback after,
  StackLoaderStore loading,
) {
  sShowAlertPopup(
    context,
    primaryText: '',
    secondaryText: intl.simple_card_account_verification,
    primaryButtonName: intl.simple_card_verify_account,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () async {
      try {
        sAnalytics.tapVerifyAccountForCard();
        loading.finishLoadingImmediately();
        Navigator.pop(context);

        getIt.get<GlobalLoader>().setLoading(true);
        sAnalytics.viewPleaseWaitLoading();

        final kycPlan = await getKYCAidPlan();

        if (kycPlan == null) return;

        if (kycPlan.provider == KycProvider.sumsub) {
          await getIt<SumsubService>().launch(
            isBanking: true,
            needPush: false,
            onFinish: () {
              after();
              getIt.get<GlobalLoader>().setLoading(false);
            },
            isCard: true,
          );
        } else if (kycPlan.provider == KycProvider.kycAid) {
          getIt.get<GlobalLoader>().setLoading(false);
          await startKycAidFlow(kycPlan);
        }
      } catch (e) {
        getIt.get<GlobalLoader>().setLoading(false);
      }
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      sAnalytics.tapCancelKYCForCard();
      loading.finishLoadingImmediately();
      Navigator.pop(context);
      getIt.get<GlobalLoader>().setLoading(false);
    },
  );
}
