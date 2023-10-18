import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

void showCreatePersonalAccount(BuildContext context, StackLoaderStore loading) {
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

      await getIt<SumsubService>().launch(
        isBanking: true,
        onFinish: () {
          loading.finishLoadingImmediately();
        },
      );
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      Navigator.pop(context);

      loading.finishLoadingImmediately();
    },
  );
}
