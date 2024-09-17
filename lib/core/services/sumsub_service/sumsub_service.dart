import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:logger/logger.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';

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

  Future<String?> getBankingToken() async {
    final request = await sNetwork.getWalletModule().postBankingKycStart();

    if (request.hasError) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: _loggerService,
            message: 'Get SDK Token error: ${request.error}',
          );
    }

    return request.data;
  }

  Future<String?> getFacecheckToken() async {
    final countries = getIt.get<KycCountryStore>();
    final request = await sNetwork.getWalletModule().postFaceSDKToken(
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

  Future<void> launch({
    VoidCallback? onFinish,
    required bool isBanking,
    bool needPush = true,
    bool isCard = false,
  }) async {
    try {
      unawaited(
        _logMessage(
          'Start launch function isBanking: $isBanking, needPush: $needPush, isCard: $isCard',
        ),
      );
      final countries = getIt.get<KycCountryStore>();
      if (isCard) {
        sAnalytics.viewKYCSumsubCreation();
      }

      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: _loggerService,
            message: 'Launch',
          );

      void onStatusChanged(
        SNSMobileSDKStatus newStatus,
        SNSMobileSDKStatus prevStatus,
      ) {
        unawaited(
          _logMessage(
            'The SDK status was changed: $prevStatus -> $newStatus',
          ),
        );

        getIt.get<GlobalLoader>().setLoading(false);

        getIt.get<SimpleLoggerService>().log(
              level: Level.info,
              place: _loggerService,
              message: 'The SDK status was changed: $prevStatus -> $newStatus',
            );

        if (newStatus == SNSMobileSDKStatus.Approved ||
            newStatus == SNSMobileSDKStatus.ActionCompleted ||
            newStatus == SNSMobileSDKStatus.Pending) {
          if (!isBanking) {
            if (needPush) {
              sAnalytics.kycFlowVerifyingNowSV(
                country: countries.activeCountry?.countryName ?? '',
              );

              sRouter.push(
                SuccessScreenRouter(
                  time: 6,
                  primaryText: intl.kycChooseDocuments_verifyingNow,
                  secondaryText: intl.kycChooseDocuments_willBeNotified,
                  onCloseButton: () async {
                    if (onFinish != null) onFinish();
                  },
                  onSuccess: (p0) {
                    navigateToRouter();

                    if (onFinish != null) onFinish();
                  },
                ),
              );
            } else {
              if (onFinish != null) onFinish();
            }
          } else {
            if (onFinish != null) onFinish();
          }
        }
      }

      Future<SNSActionResultHandlerReaction> onActionResult(
        SNSMobileSDKActionResult result,
      ) {
        sAnalytics.kycFlowVerifyingNowSV(
          country: countries.activeCountry?.countryName ?? '',
        );

        unawaited(_logMessage('In onActionResult: $result'));

        if (!isBanking) {
          if (needPush) {
            sRouter.push(
              SuccessScreenRouter(
                time: 6,
                primaryText: intl.kycChooseDocuments_verifyingNow,
                secondaryText: intl.kycChooseDocuments_willBeNotified,
                onCloseButton: () async {
                  if (onFinish != null) onFinish();
                },
              ),
            );
          } else {
            if (onFinish != null) onFinish();
          }
        } else {
          if (onFinish != null) onFinish();
        }

        return Future.value(SNSActionResultHandlerReaction.Continue);
      }

      unawaited(_logMessage('befor initToken'));

      final initToken = isBanking ? await getBankingToken() : await getSDKToken();

      unawaited(_logMessage('after initToken: $initToken'));

      void onEvent(SNSMobileSDKEvent event) {
        if (event.eventType == 'ApplicantLoaded') {
          getIt.get<GlobalLoader>().setLoading(false);
        }
      }

      unawaited(_logMessage('befor snsMobileSDK'));

      final snsMobileSDK = SNSMobileSDK.init(initToken ?? '', getSDKToken)
          .withHandlers(
            onStatusChanged: onStatusChanged,
            onActionResult: onActionResult,
            onEvent: onEvent,
          )
          .withDebug(false)
          .withLocale(
            Locale(intl.localeName),
          )
          .withAutoCloseOnApprove(0)
          .build();

      unawaited(_logMessage('after snsMobileSDK: $snsMobileSDK'));

      unawaited(_logMessage('befor snsMobileSDK.launch'));

      final _ = await snsMobileSDK.launch();

      unawaited(_logMessage('after snsMobileSDK.launch'));

      Future.delayed(const Duration(seconds: 3), () {
        getIt.get<GlobalLoader>().setLoading(false);
        unawaited(_logMessage('GlobalLoader = false'));
      });
    } catch (e) {
      unawaited(_logMessage('Error: $e', level: 'error'));
    }
  }

  void simulateSuccess({
    VoidCallback? onFinish,
    required bool isBanking,
    bool needPush = true,
  }) {
    if (needPush) {
      sRouter.push(
        SuccessScreenRouter(
          primaryText: intl.kycChooseDocuments_verifyingNow,
          secondaryText: intl.kycChooseDocuments_willBeNotified,
          onCloseButton: () async {
            if (onFinish != null) onFinish();
          },
          onSuccess: (p0) {
            navigateToRouter();

            if (onFinish != null) onFinish();
          },
        ),
      );
    } else {
      if (onFinish != null) onFinish();
    }
  }

  Future<void> launchFacecheck(
    VoidCallback callback,
  ) async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: _loggerService,
          message: 'Launch',
        );

    Future<void> onStatusChanged(
      SNSMobileSDKStatus newStatus,
      SNSMobileSDKStatus prevStatus,
    ) async {
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: _loggerService,
            message: 'The FACE CHECK SDK status was changed: $prevStatus -> $newStatus',
          );

      if (newStatus == SNSMobileSDKStatus.Approved ||
          newStatus == SNSMobileSDKStatus.ActionCompleted ||
          newStatus == SNSMobileSDKStatus.Pending) {
        callback();
      }
    }

    Future<SNSActionResultHandlerReaction> onActionResult(
      SNSMobileSDKActionResult result,
    ) async {
      return Future.value(SNSActionResultHandlerReaction.Continue);
    }

    final initToken = await getFacecheckToken();

    try {
      final snsMobileSDK = SNSMobileSDK.init(initToken ?? '', getFacecheckToken)
          .withHandlers(
            onStatusChanged: onStatusChanged,
            onActionResult: onActionResult,
          )
          .withDebug(false)
          .withLocale(
            Locale(intl.localeName),
          )
          .withAutoCloseOnApprove(0)
          .build();

      final _ = await snsMobileSDK.launch();
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: _loggerService,
            message: 'onStatusChanged error: $e',
          );
    }
  }

  Future<void> _logMessage(
    String message, {
    String level = 'info',
    String process = 'launch',
  }) async {
    unawaited(
      getIt.get<SNetwork>().simpleNetworkingUnathorized.getLogsApiModule().postAddLog(
            AddLogModel(
              level: level,
              message: message,
              source: 'SumsubService',
              process: process,
              token: await getIt.get<LocalStorageService>().getValue(refreshTokenKey),
            ),
          ),
    );
  }
}
