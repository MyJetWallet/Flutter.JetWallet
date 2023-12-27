// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/core/services/zendesk_support_service/zendesk_service.dart';
import 'package:jetwallet/features/actions/action_deposit/action_deposit.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/auth/email_verification/store/email_verification_store.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/features/send_gift/widgets/share_gift_result_bottom_sheet.dart';
import 'package:jetwallet/features/withdrawal/model/withdrawal_confirm_model.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

import 'local_storage_service.dart';
import 'notification_service.dart';
import 'remote_config/models/remote_config_union.dart';
import 'simple_networking/simple_networking.dart';

/// Parameters
const _code = 'jw_code';
const _command = 'jw_command';
const _operationId = 'jw_operation_id';
const _email = 'jw_email';

// when parameters come in "/" format as part of the link
const _action = 'action';

const jw_deposit_successful = 'jw_deposit_successful';
const jw_support_page = 'jw_support_page';
const jw_kyc_documents_declined = 'jw_kyc_documents_declined';

// gift
const jw_gift_incoming = 'jw_gift_incoming';
const jw_gift_remind = 'jw_gift_remind';
const jw_gift_cancelled = 'jw_gift_cancelled';
const jw_gift_expired = 'jw_gift_expired';

/// Commands
const _confirmEmail = 'ConfirmEmail';
const _confirmWithdraw = 'VerifyWithdrawal';
const _inviteFriend = 'InviteFriend';
const _referralRedirect = 'ReferralRedirect';
const _depositStart = 'DepositStart';
const _kycVerification = 'KycVerification';
const _marketsScreen = 'MarketsScreen';

// Push Notification

const _jwSwap = 'jw_operation_history';
const _jwTransferByPhoneSend = 'jw_transfer_by_phone_send';
const _jwCrypto_withdrawal_decline = 'jw_crypto_withdrawal_decline';
const _jwKycBanned = 'jw_kyc_banned';

const String _loggerService = 'DeepLinkService';

enum SourceScreen {
  bannerOnMarket,
  bannerOnRewards,
  accountScreen,
}

class DeepLinkService {
  DeepLinkService();

  void handle(
    Uri link, {
    SourceScreen? source,
    bool? fromBG,
  }) {
    // old version
    var parameters = link.queryParameters;

    final path = link.path.replaceFirst('/', '').split('/');

    // new version
    if (path.length.isEven) {
      if (path[0] == _action) {
        final names = <String>[];
        final values = <String>[];

        for (var i = 0; i < (path.length / 2); i++) {
          names.add(path[i * 2] == _action ? _command : path[i * 2]);
          values.add(path[(i * 2) + 1]);
        }

        parameters = {
          for (var i = 0; i < names.length; i++) names[i]: values[i],
        };
      }
    }

    final command = parameters[_command];

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'DeepLinkService GET',
          message: '$command $parameters. $path',
        );

    if (command == _confirmEmail) {
      _confirmEmailCommand(parameters);
    } else if (command == _confirmWithdraw) {
      _confirmWithdrawCommand(parameters);
    } else if (command == _inviteFriend) {
      _inviteFriendCommand();
    } else if (command == _referralRedirect) {
      _referralRedirectCommand(parameters);
    } else if (command == _kycVerification) {
      _kycVerificationCommand();
    } else if (command == _depositStart) {
      _depositStartCommand(source);
    } else if (command == _jwSwap) {
      pushCryptoHistory(parameters);
    } else if (command == _jwTransferByPhoneSend) {
      pushCryptoWithdrawal(parameters);
    } else if (command == _jwCrypto_withdrawal_decline) {
      pushWithrawalDecline(parameters);
    } else if (command == jw_deposit_successful) {
      pushDepositSuccess(parameters);
    } else if (command == jw_support_page) {
      pushSupportPage(parameters);
    } else if (command == jw_kyc_documents_declined) {
      pushDocumentNotVerified(parameters);
    } else if (command == jw_gift_incoming) {
      //just open the application
    } else if (command == jw_gift_remind) {
      pushRemindGiftBottomSheet(parameters);
    } else if (command == _marketsScreen) {
      pushMarketsScreen(parameters);
    } else if (command == _jwKycBanned) {
      pushDocumentNotVerified(parameters);
    } else {
      if (parameters.containsKey('jw_operation_id')) {
        pushCryptoHistory(parameters);
      }
    }
  }

  Future<void> _depositStartCommand(SourceScreen? source) async {
    final appStore = getIt.get<AppStore>();

    if (source == SourceScreen.bannerOnMarket) {
      await sRouter.push(RewardsRouter(actualRewards: const []));
    } else if (source == SourceScreen.bannerOnRewards) {
      appStore.setOpenBottomMenu(true);

      await sRouter.pop();
    }
  }

  void _kycVerificationCommand() {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      final kycState = getIt.get<KycService>();
      final kycAlertHandler = getIt.get<KycAlertHandler>();

      final isDepositAllow = kycState.depositStatus != kycOperationStatus(KycStatus.allowed);
      final isWithdrawalAllow = kycState.withdrawalStatus != kycOperationStatus(KycStatus.allowed);

      kycAlertHandler.handle(
        status: isDepositAllow
            ? kycState.depositStatus
            : isWithdrawalAllow
                ? kycState.withdrawalStatus
                : kycState.tradeStatus,
        isProgress: kycState.verificationInProgress,
        currentNavigate: () {},
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final kycState = getIt.get<KycService>();
            final kycAlertHandler = getIt.get<KycAlertHandler>();

            final isDepositAllow = kycState.depositStatus != kycOperationStatus(KycStatus.allowed);
            final isWithdrawalAllow = kycState.withdrawalStatus != kycOperationStatus(KycStatus.allowed);

            kycAlertHandler.handle(
              status: isDepositAllow
                  ? kycState.depositStatus
                  : isWithdrawalAllow
                      ? kycState.withdrawalStatus
                      : kycState.tradeStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () {},
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          },
        ),
      );
    }
  }

  void _confirmEmailCommand(Map<String, String> parameters) {
    getIt.get<EmailVerificationStore>().updateCode(
          parameters[_code],
        );
  }

  void _confirmWithdrawCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;

    //getIt.get<WithdrawalConfirmStore>().updateCode(code, id);

    getIt.get<EventBus>().fire(WithdrawalConfirmModel(code: code, operationID: id));
  }

  void _inviteFriendCommand() {
    Future<void> openRewards() async {
      await Future.delayed(const Duration(seconds: 1));

      if (getIt.get<AppStore>().authStatus == const AuthorizationUnion.authorized() &&
          (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
              .where((element) => element.id == AssetPaymentProductsEnum.rewardsOnboardingProgram)
              .isNotEmpty) {
        getIt<AppStore>().setHomeTab(3);
        if (getIt<AppStore>().tabsRouter != null) {
          getIt<AppStore>().tabsRouter!.setActiveIndex(3);
        }
      } else {
        getIt<AppStore>().setHomeTab(0);
        if (getIt<AppStore>().tabsRouter != null) {
          getIt<AppStore>().tabsRouter!.setActiveIndex(0);
        }
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      openRewards();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await openRewards();
          },
        ),
      );
    }
  }

  Future<void> _referralRedirectCommand(Map<String, String> parameters) async {
    try {
      final storage = sLocalStorageService;
      final deviceInfo = sDeviceInfo.model;
      final referralCode = parameters[_code];

      await storage.setString(referralCodeKey, referralCode);
      await checkInitAppFBAnalytics(storage, deviceInfo);

      await getIt.get<ReferallCodeStore>().init();
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'DeepLinkService',
            message: e.toString(),
          );
    }
  }

  /// Push Notification Links

  Future<void> handlePushNotificationLink(RemoteMessage message) async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: _loggerService,
          message: 'handlePushNotificationLink \n\n ${message.data["actionUrl"]}',
        );

    // data: {actionUrl: http://simple.app/action/jw_swap/jw_operation_id/a93fa24f9f544774863e4e7b4c07f3c0},

    if (message.data['actionUrl'] != null) {
      handle(Uri.parse(message.data['actionUrl'] as String));
    }
  }

  Future<void> pushCryptoHistory(
    Map<String, String> parameters,
  ) async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      await sRouter.push(
        TransactionHistoryRouter(
          jwOperationId: parameters['jw_operation_id'],
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          action: RouteQueryAction.push,
          query: TransactionHistoryRouter(
            jwOperationId: parameters['jw_operation_id'],
          ),
        ),
      );
    }
  }

  Future<void> pushCryptoWithdrawal(
    Map<String, String> parameters,
  ) async {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      'BTC',
    );

    //navigateToWallet

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      await sRouter.push(
        WalletRouter(
          currency: currency,
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          action: RouteQueryAction.push,
          query: WalletRouter(
            currency: currency,
          ),
        ),
      );
    }
  }

  Future<void> pushWithrawalDecline(
    Map<String, String> parameters,
  ) async {
    //navigateToWallet

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      final currency = currencyFrom(
        sSignalRModules.currenciesList,
        parameters['jw_asset'] ?? 'BTC',
      );

      await sRouter.push(
        WalletRouter(
          currency: currency,
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final currency = currencyFrom(
              sSignalRModules.currenciesList,
              parameters['jw_asset'] ?? 'BTC',
            );
            await sRouter.push(
              WalletRouter(
                currency: currency,
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> pushDepositSuccess(
    Map<String, String> parameters,
  ) async {
    if (parameters['jw_operation_id'] == null) return;

    //navigateToWallet
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      final currency = currencyFrom(
        sSignalRModules.currenciesList,
        parameters['jw_operation_id']!,
      );

      await sRouter.push(
        WalletRouter(
          currency: currency,
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () {
            final currency = currencyFrom(
              sSignalRModules.currenciesList,
              parameters['jw_operation_id']!,
            );

            sRouter.push(
              WalletRouter(
                currency: currency,
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> pushSupportPage(
    Map<String, String> parameters,
  ) async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      if (showZendesk) {
        await getIt.get<ZenDeskService>().showZenDesk();
      } else {
        await sRouter.push(
          CrispRouter(
            welcomeText: intl.crispSendMessage_hi,
          ),
        );
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          action: RouteQueryAction.push,
          func: () async {
            if (showZendesk) {
              await getIt.get<ZenDeskService>().showZenDesk();
            } else {
              await sRouter.push(
                CrispRouter(
                  welcomeText: intl.crispSendMessage_hi,
                ),
              );
            }
          },
        ),
      );
    }
  }

  Future<void> pushDocumentNotVerified(
    Map<String, String> parameters,
  ) async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      await sRouter.push(
        const AccountRouter(),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          action: RouteQueryAction.push,
          query: const AccountRouter(),
        ),
      );
    }
  }

  Future<void> pushRemindGiftBottomSheet(
    Map<String, String> parameters,
  ) async {
    final jwOperationId = parameters['jw_operation_id'];
    if (jwOperationId == null) return;

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      final gift = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().getGift(jwOperationId);

      if (gift.data == null) return;
      final currency = currencyFrom(
        sSignalRModules.currenciesList,
        gift.data?.assetSymbol ?? '',
      );
      final context = sRouter.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        shareGiftResultBottomSheet(
          context: context,
          amount: gift.data?.amount ?? Decimal.zero,
          currency: currency,
          email: gift.data?.toEmail,
          phoneNumber: gift.data?.toPhoneNumber,
        );
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final gift = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().getGift(jwOperationId);
            if (gift.data == null) return;
            final currency = currencyFrom(
              sSignalRModules.currenciesList,
              gift.data?.assetSymbol ?? '',
            );
            final context = sRouter.navigatorKey.currentContext;
            if (context != null && context.mounted) {
              shareGiftResultBottomSheet(
                context: context,
                amount: gift.data?.amount ?? Decimal.zero,
                currency: currency,
              );
            }
          },
        ),
      );
    }
  }

  Future<void> pushMarketsScreen(
    Map<String, String> parameters,
  ) async {
    final jwOperationId = parameters['jw_symbol'];

    Future<void> openMarket() async {
      await Future.delayed(const Duration(milliseconds: 650));

      if (getIt.get<AppStore>().authStatus == const AuthorizationUnion.authorized()) {
        if (jwOperationId != null) {
          final marketItem = sSignalRModules.getMarketPrices.indexWhere((element) => element.symbol == jwOperationId);
          if (marketItem != -1) {
            await sRouter.push(
              MarketDetailsRouter(
                marketItem: sSignalRModules.getMarketPrices[marketItem],
              ),
            );
          } else {
            getIt<AppStore>().setHomeTab(1);
            if (getIt<AppStore>().tabsRouter != null) {
              getIt<AppStore>().tabsRouter!.setActiveIndex(1);
            }
          }
        } else {
          getIt<AppStore>().setHomeTab(1);
          if (getIt<AppStore>().tabsRouter != null) {
            getIt<AppStore>().tabsRouter!.setActiveIndex(1);
          }
        }
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      await openMarket();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await openMarket();
          },
        ),
      );
    }
  }
}
