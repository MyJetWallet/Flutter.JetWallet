import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/crypto_card/utils/show_please_verify_account_popup.dart';
import 'package:jetwallet/features/crypto_card/utils/show_upload_international_passport_popup.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/get_kuc_aid_plan.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/start_kyc_aid_flow.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

part 'get_crypto_card_store.g.dart';

class GetCryptoCardStore extends _GetCryptoCardStoreBase with _$GetCryptoCardStore {
  GetCryptoCardStore() : super();

  static _GetCryptoCardStoreBase of(BuildContext context) => Provider.of<GetCryptoCardStore>(context);
}

abstract class _GetCryptoCardStoreBase with Store {
  @action
  Future<void> startCreatingFlow() async {
    final context = sRouter.navigatorKey.currentContext;
    if (context == null) return;
    // TODO (Yaroslav): add status check
    await showUploadInternationalPassportPopup(context: context);
    await _checkKycState(
      onKycAllowed: () async {
        await sRouter.push(const CryptoCardPayAssetRoute());
      },
    );
  }

  @action
  Future<void> _checkKycState({required Future<void> Function() onKycAllowed}) async {
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    if (kycState.verificationRequired) {
      final context = sRouter.navigatorKey.currentContext;
      if (context == null) return;
      final result = await showPleaseVerifyAccountPopUp(context: context);
      if (result == true) {
        await _startKycVereficationFlow();
      }
    } else {
      kycAlertHandler.handle(
        status: kycState.depositStatus,
        isProgress: kycState.verificationInProgress,
        currentNavigate: () async {
          await onKycAllowed();
        },
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
        customBlockerText: intl.profile_kyc_bloked_alert,
      );
    }
  }

  @action
  Future<void> _startKycVereficationFlow() async {
    final kycPlan = await getKYCAidPlan();
    if (kycPlan == null) return;

    if (kycPlan.provider == KycProvider.sumsub) {
      await getIt<SumsubService>().launch(
        isBanking: false,
      );
    } else if (kycPlan.provider == KycProvider.kycAid) {
      await startKycAidFlow(kycPlan);
    }
  }
}
