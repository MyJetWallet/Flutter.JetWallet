import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/get_kuc_aid_plan.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/start_kyc_aid_flow.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

void showCreatePersonalAccount(
  BuildContext context,
  StackLoaderStore loading,
  VoidCallback after,
) {
  sAnalytics.eurWalletPleasePassVerificaton();
  sShowAlertPopup(
    context,
    primaryText: '',
    secondaryText: intl.create_personal_account,
    primaryButtonName: intl.create_personal_verify_account,
    image: Image.asset(
      infoLightAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    ),
    onPrimaryButtonTap: () async {
      Navigator.pop(context);

      sAnalytics.eurWalletVerifyAccountPartnerSide();

      loading.startLoadingImmediately();

      Future.delayed(const Duration(seconds: 1), () {
        loading.finishLoadingImmediately();
      });

      getIt.get<GlobalLoader>().setLoading(true);

      final kycPlan = await getKYCAidPlan();

      getIt.get<GlobalLoader>().setLoading(false);

      if (kycPlan == null) return;

      if (kycPlan.provider == KycProvider.sumsub) {
        await getIt<SumsubService>().launch(
          isBanking: true,
          needPush: false,
          onFinish: () {
            after();
            loading.finishLoadingImmediately();
          },
        );
      } else if (kycPlan.provider == KycProvider.kycAid) {
        loading.finishLoadingImmediately();
        await startKycAidFlow(kycPlan);
      }
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      Navigator.pop(context);

      loading.finishLoadingImmediately();
    },
  );
}
