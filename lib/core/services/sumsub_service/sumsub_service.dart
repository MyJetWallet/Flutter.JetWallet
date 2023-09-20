import 'package:flutter/material.dart';
import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../features/kyc/choose_documents/store/kyc_country_store.dart';
import '../../../utils/helpers/navigate_to_router.dart';
import '../../router/app_router.dart';

const String _loggerService = 'SumsubService';

class SumsubService {
  Future<String?> getSDKToken() async {
    final countries = getIt.get<KycCountryStore>();
    final request = await sNetwork.getWalletModule().postSDKToken(
          countries.activeCountry!.countryCode,
        );

    if (request.hasError) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: _loggerService,
            message: 'Get SDK Token error: ${request.error}',
          );
    }

    return request.data;
  }

  Future<void> launch() async {
    final countries = getIt.get<KycCountryStore>();

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: _loggerService,
          message: 'Launch',
        );

    onStatusChanged(
      SNSMobileSDKStatus newStatus,
      SNSMobileSDKStatus prevStatus,
    ) {
      sAnalytics.kycFlowSumsubClose(
        country: countries.activeCountry?.countryName ?? '',
      );

      print('The SDK status was changed: $prevStatus -> $newStatus');
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: _loggerService,
            message: 'The SDK status was changed: $prevStatus -> $newStatus',
          );
      if (newStatus == SNSMobileSDKStatus.Approved ||
          newStatus == SNSMobileSDKStatus.ActionCompleted ||
          newStatus == SNSMobileSDKStatus.Pending) {
        sAnalytics.kycFlowVerifyingNowSV(
          country: countries.activeCountry?.countryName ?? '',
        );

        sRouter.push(
          SuccessScreenRouter(
            primaryText: intl.kycChooseDocuments_verifyingNow,
            secondaryText: intl.kycChooseDocuments_willBeNotified,
            showPrimaryButton: true,
            buttonText: intl.previewBuyWithUmlimint_close,
            onActionButton: () async {
              navigateToRouter();
            },
          ),
        );
      }
    }

    onActionResult(SNSMobileSDKActionResult result) {
      sAnalytics.kycFlowVerifyingNowSV(
        country: countries.activeCountry?.countryName ?? '',
      );

      sRouter.push(
        SuccessScreenRouter(
          primaryText: intl.kycChooseDocuments_verifyingNow,
          secondaryText: intl.kycChooseDocuments_willBeNotified,
          showPrimaryButton: true,
          buttonText: intl.previewBuyWithUmlimint_close,
          onActionButton: () async {
            navigateToRouter();
          },
        ),
      );

      return Future.value(SNSActionResultHandlerReaction.Continue);
    }

    final initToken = await getSDKToken();

    final snsMobileSDK = SNSMobileSDK.init(initToken ?? '', getSDKToken)
        .withHandlers(
          onStatusChanged: onStatusChanged,
          onActionResult: onActionResult,
        )
        .withDebug(true)
        .withLocale(
          Locale(intl.localeName),
        )
        .withAutoCloseOnApprove(0)
        .build();

    final SNSMobileSDKResult result = await snsMobileSDK.launch();
  }
}
