import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

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
      loading.finishLoadingImmediately();
      Navigator.pop(context);

      getIt.get<GlobalLoader>().setLoading(true);

      await getIt<SumsubService>().launch(
        isBanking: true,
        needPush: false,
        onFinish: () {
          after();
          getIt.get<GlobalLoader>().setLoading(false);
        },
      );
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      loading.finishLoadingImmediately();
      Navigator.pop(context);
      getIt.get<GlobalLoader>().setLoading(false);
    },
  );
}
