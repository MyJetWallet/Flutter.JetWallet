// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/anchors/anchors_service.dart';
import 'package:jetwallet/core/services/anchors/models/convert_confirmation_model/convert_confirmation_model.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/push_notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/auth/email_verification/store/email_verification_store.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/change_email/store/change_email_verification_store.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_scroll_store.dart';
import 'package:jetwallet/features/send_gift/widgets/share_gift_result_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_store.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_options.dart';
import 'package:jetwallet/features/withdrawal/model/withdrawal_confirm_model.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:logger/logger.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import '../../features/app/timer_service.dart';
import '../../features/wallet/helper/navigate_to_wallet.dart';
import 'local_storage_service.dart';
import 'remote_config/models/remote_config_union.dart';
import 'simple_networking/simple_networking.dart';
import 'user_info/user_info_service.dart';

/// Parameters
const _code = 'jw_code';
const _command = 'jw_command';
const _operationId = 'jw_operation_id';
const _utmSource = 'utm_source';

// when parameters come in "/" format as part of the link
const _action = 'action';

const jw_deposit_successful = 'jw_deposit_successful';
const jw_support_page = 'jw_support_page';

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
const _rateUpCommand = 'rate_up';

// Push Notification

const _jwSwap = 'jw_operation_history';
const _jwTransferByPhoneSend = 'jw_transfer_by_phone_send';
const _jwCrypto_withdrawal_decline = 'jw_crypto_withdrawal_decline';
const _jwKycBanned = 'jw_kyc_banned';

// Earn
const _earnScreen = 'earn_screen';
const _jwSymbol = 'jw_symbol';

// Tech
const _techScreen = 'tech_screen';
const _jwParameter = 'jw_parameter';

// Profile screen
const _profile_screen = 'profile_screen';

// Simple Card
const _get_simple_card = 'get_simple_card';
const _card_screen = 'card_screen';

// Asset screen
const _assetScreen = 'asset_screen';

//Simple coin
const _mySimpleCoinsScreen = 'my_simple_coins_screen';

//History
const jwOperationPtpManage = 'jw_operation_ptp_manage';

const String _loggerService = 'DeepLinkService';

//Jar
const _jar = 'jar';
const _jwJarId = 'jw_jar_id';

// Market Sector
const _market_sector = 'market_sector';
const _jw_sector_id = 'jw_sector_id';

//Card Preorder
const _card_preorder = 'card_preorder';

//Crypto card
const _crypto_card = 'crypto_card';

// Unfinished operation
const _unfinishedOperation = 'UnfinishedOperation';
const _fromAsset = 'jw_fromAsset';
const _toAsset = 'jw_toAsset';
const _fromAmount = 'jw_fromAmount';
const _toAmount = 'jw_toAmount';
const _isFromFixed = 'jw_isFromFixed';
const _operation = 'jw_operation';
const _cardId = 'jw_cardId';
const _receiveMethodId = 'jw_receiveMethodId';

enum SourceScreen {
  bannerOnMarket,
  bannerOnRewards,
  accountScreen,
}

class DeepLinkService {
  DeepLinkService();

  String? lastDeepLink;
  DateTime? lastDeepLinkTime;

  Future<void> handle(
    Uri link, {
    SourceScreen? source,
    bool? fromBG,
    String? messageId,
  }) async {
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
    final utmSource = parameters[_utmSource];

    if (utmSource != null) {
      await _saveUtmSourse(utm: utmSource);
    }

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'DeepLinkService GET',
          message: '$command $parameters. $path',
        );

    if (AnchorsHelper.allAnchorTypes.contains(command)) {
      await getIt.get<AnchorsService>().handleDeeplink(
            type: command!,
            metadata: parameters,
            messageId: messageId,
          );
    } else if (command == _confirmEmail) {
      _confirmEmailCommand(parameters);
    } else if (command == _confirmWithdraw) {
      _confirmWithdrawCommand(parameters);
    } else if (command == _inviteFriend) {
      await _inviteFriendCommand();
      if (messageId != null && messageId.isNotEmpty) {
        unawaited(logPushNotificationToBD(messageId, 2));
      }
    } else if (command == _referralRedirect) {
      await _referralRedirectCommand(parameters);
    } else if (command == _kycVerification) {
      _kycVerificationCommand();
    } else if (command == _depositStart) {
      await _depositStartCommand(source);
    } else if (command == _jwSwap) {
      await pushCryptoHistory(parameters);
    } else if (command == _jwTransferByPhoneSend) {
      await pushCryptoWithdrawal(parameters);
    } else if (command == _jwCrypto_withdrawal_decline) {
      await pushWithrawalDecline(parameters);
    } else if (command == jw_deposit_successful) {
      await pushDepositSuccess(parameters);
    } else if (command == jw_support_page) {
      await pushSupportPage(parameters);
    } else if (command == jw_gift_incoming) {
      //just open the application
    } else if (command == jw_gift_remind) {
      await pushRemindGiftBottomSheet(parameters);
    } else if (command == _marketsScreen) {
      await pushMarketsScreen(parameters);
    } else if (command == _jwKycBanned) {
      await pushDocumentNotVerified(parameters);
    } else if (command == _rateUpCommand) {
      await pushRateUp(parameters);
    } else if (command == _earnScreen) {
      await showEarnScreen(parameters);
    } else if (command == _techScreen) {
      await showTechToast(parameters);
    } else if (command == _profile_screen) {
      await pushProfileScreen(parameters);
    } else if (command == _get_simple_card) {
      await showGetSimpleCard(parameters);
    } else if (command == _card_screen) {
      await pushSimpleCardScreen(parameters);
    } else if (command == _assetScreen) {
      await _pushAssetScreen(parameters);
    } else if (command == _mySimpleCoinsScreen) {
      await _pushMySimpleCoinsScreen(parameters);
    } else if (command == _jar) {
      await _pushJar(parameters);
    } else if (command == _market_sector) {
      await openMarketSectorScreen(parameters);
    } else if (command == _card_preorder) {
      await openCardPreorderTab(parameters);
    } else if (command == _unfinishedOperation) {
      await _pushUnfinishedOperationFlow(parameters);
    } else if (command == _crypto_card) {
      await openCryptoCardTab(parameters);
    } else {
      if (parameters.containsKey('jw_operation_id')) {
        await pushCryptoHistory(parameters);
      }
    }

    if (messageId != null && messageId.isNotEmpty) {
      if (getIt.isRegistered<AppStore>() &&
          getIt.get<AppStore>().remoteConfigStatus is Success &&
          getIt.get<AppStore>().authorizedStatus is Home &&
          getIt<TimerService>().isPinScreenOpen == false) {
        await logPushNotificationToBD(messageId, 2);
      } else {
        getIt<RouteQueryService>().addToQuery(
          RouteQueryModel(
            func: () async {
              await Future.delayed(const Duration(seconds: 1));
              await logPushNotificationToBD(messageId, 2);
            },
          ),
        );
      }
    }
  }

  Future<void> _depositStartCommand(SourceScreen? source) async {
    final appStore = getIt.get<AppStore>();

    if (source == SourceScreen.bannerOnMarket) {
      await Future.delayed(const Duration(milliseconds: 100));
      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.rewards);
    } else if (source == SourceScreen.bannerOnRewards) {
      appStore.setOpenBottomMenu(true);

      await sRouter.maybePop();
    }
  }

  void _kycVerificationCommand() {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
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

  Future<void> _pushUnfinishedOperationFlow(
    Map<String, String> parameters,
  ) async {
    final operation = parameters[_operation];

    final fromAsset = parameters[_fromAsset];
    final toAsset = parameters[_toAsset];
    final fromAmountValue = parameters[_fromAmount];
    final toAmountValue = parameters[_toAmount];
    final isFromFixed = bool.tryParse(parameters[_isFromFixed] ?? '');

    if (fromAsset == null ||
        toAsset == null ||
        isFromFixed == null ||
        (fromAmountValue == null && toAmountValue == null)) {
      return;
    }

    var navigation = () async {};

    if (operation == null) {
      return;
    } else if (operation == 'buyCard') {
      final cardId = parameters[_cardId];
      if (cardId == null) {
        return;
      }

      navigation = () async {
        try {
          final fromCurrency = sSignalRModules.currenciesList.firstWhereOrNull((e) => e.symbol == fromAsset);
          final toCurrency = sSignalRModules.currenciesList.firstWhereOrNull((e) => e.symbol == toAsset);

          final cards = sSignalRModules.cards.cardInfos;
          final card = cards.firstWhereOrNull((element) => element.id == cardId);

          sRouter.popUntilRoot();

          final isPageRouterNow = sRouter.stack.any((rout) => rout.name == BuyConfirmationRoute.name);
          if (!isPageRouterNow) {
            await sRouter.push(
              BuyConfirmationRoute(
                paymentCurrency: fromCurrency!,
                asset: toCurrency!,
                isFromFixed: isFromFixed,
                fromAmount: fromAmountValue,
                toAmount: toAmountValue,
                card: card,
              ),
            );
          }
        } catch (e) {
          if (kDebugMode) {
            print('[DeepLinkService] buySimpleAccount error $e');
          }
        }
      };
    } else if (operation == 'buyP2P') {
      final receiveMethodId = parameters[_receiveMethodId];
      if (receiveMethodId == null) {
        return;
      }

      navigation = () async {
        try {
          final toCurrency = sSignalRModules.currenciesList.firstWhereOrNull((e) => e.symbol == toAsset);

          final p2pBuyMethod =
              toCurrency!.buyMethods.firstWhereOrNull((buyMethod) => buyMethod.id == PaymentMethodType.paymeP2P);
          final paymentAsset = p2pBuyMethod?.paymentAssets?.firstWhereOrNull((element) => element.asset == fromAsset);
          if (paymentAsset == null) {
            return;
          }

          final p2pMethods = <P2PMethodModel>[];
          final response = await sNetwork.getWalletModule().getP2PMethods();
          final result = response.data?.methods ?? [];
          p2pMethods.addAll(result);
          final p2pMethod = p2pMethods.firstWhereOrNull(
            (method) => method.methodId == receiveMethodId,
          );

          if (p2pMethod == null) {
            return;
          }

          sRouter.popUntilRoot();

          final isPageRouterNow = sRouter.stack.any((rout) => rout.name == BuyP2PConfirmationRoute.name);
          if (!isPageRouterNow) {
            await sRouter.push(
              BuyP2PConfirmationRoute(
                asset: toCurrency,
                paymentAsset: paymentAsset,
                isFromFixed: isFromFixed,
                fromAmount: fromAmountValue,
                toAmount: toAmountValue,
                p2pMethod: p2pMethod,
              ),
            );
          }
        } catch (e) {
          if (kDebugMode) {
            print('[DeepLinkService] buySimpleAccount error $e');
          }
        }
      };
    } else if (operation == 'buySimpleAccount') {
      navigation = () async {
        try {
          final fromCurrency = sSignalRModules.currenciesList.firstWhereOrNull((e) => e.symbol == fromAsset);
          final toCurrency = sSignalRModules.currenciesList.firstWhereOrNull((e) => e.symbol == toAsset);
          final simpleAccount = sSignalRModules.bankingProfileData?.simple!.account;

          if (simpleAccount == null) {
            return;
          }

          sRouter.popUntilRoot();

          final isPageRouterNow = sRouter.stack.any((rout) => rout.name == BuyConfirmationRoute.name);
          if (!isPageRouterNow) {
            await sRouter.push(
              BuyConfirmationRoute(
                paymentCurrency: fromCurrency!,
                asset: toCurrency!,
                isFromFixed: isFromFixed,
                fromAmount: fromAmountValue,
                toAmount: toAmountValue,
                account: simpleAccount,
              ),
            );
          }
        } catch (e) {
          if (kDebugMode) {
            print('[DeepLinkService] buySimpleAccount error $e');
          }
        }
      };
    } else if (operation == 'convert') {
      navigation = () async {
        try {
          sRouter.popUntilRoot();

          if (toAsset == 'EUR') {
            final fromCurrency =
                sSignalRModules.currenciesWithHiddenList.firstWhereOrNull((e) => e.symbol == fromAsset);
            final toCurrency = sSignalRModules.currenciesWithHiddenList.firstWhereOrNull((e) => e.symbol == toAsset);
            final simpleAccount = sSignalRModules.bankingProfileData?.simple!.account;

            if (simpleAccount == null) {
              return;
            }

            final isPageRouterNow = sRouter.stack.any((rout) => rout.name == SellConfirmationRoute.name);
            if (!isPageRouterNow) {
              await sRouter.push(
                SellConfirmationRoute(
                  paymentCurrency: toCurrency!,
                  asset: fromCurrency!,
                  isFromFixed: isFromFixed,
                  fromAmount: Decimal.parse(fromAmountValue ?? '0'),
                  toAmount: Decimal.parse(toAmountValue ?? '0'),
                  account: simpleAccount,
                ),
              );
            }
          } else {
            final isPageRouterNow = sRouter.stack.any((rout) => rout.name == ConvertConfirmationRoute.name);
            if (!isPageRouterNow) {
              await sRouter.push(
                ConvertConfirmationRoute(
                  convertConfirmationModel: ConvertConfirmationModel(
                    fromAsset: fromAsset,
                    toAsset: toAsset,
                    fromAmount: Decimal.parse(fromAmountValue ?? '0'),
                    toAmount: Decimal.parse(toAmountValue ?? '0'),
                    isFromFixed: isFromFixed,
                  ),
                ),
              );
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('[DeepLinkService] convert error $e');
          }
        }
      };
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await Future.delayed(const Duration(milliseconds: 300));

      await navigation();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await navigation();
          },
        ),
      );
    }
  }

  void _confirmEmailCommand(Map<String, String> parameters) {
    if (getIt.isRegistered<ChangeEmailVerificationStore>()) {
      getIt.get<ChangeEmailVerificationStore>().updateCode(
            parameters[_code],
          );
    } else {
      getIt.get<EmailVerificationStore>().updateCode(
            parameters[_code],
          );
    }
  }

  void _confirmWithdrawCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;

    //getIt.get<WithdrawalConfirmStore>().updateCode(code, id);

    getIt.get<EventBus>().fire(WithdrawalConfirmModel(code: code, operationID: id));
  }

  Future<void> _inviteFriendCommand() async {
    Future<void> openRewards() async {
      if (getIt.get<AppStore>().authStatus == const AuthorizationUnion.authorized() &&
          (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
              .where(
                (element) => element.id == AssetPaymentProductsEnum.rewardsOnboardingProgram,
              )
              .isNotEmpty) {
        sRouter.popUntilRoot();
        getIt<BottomBarStore>().setHomeTab(BottomItemType.rewards);
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await Future.delayed(const Duration(microseconds: 100));
      await openRewards();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await Future.delayed(const Duration(seconds: 1));
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

  ///
  /// AppsFlyer OneLink
  ///

  Future<void> handleOneLinkAction(String deepLinkValue) async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: _loggerService,
          message: 'handleOneLinkAction \n\n $deepLinkValue',
        );

    Uri uri;
    if (deepLinkValue.contains('http') || deepLinkValue.contains('https')) {
      uri = Uri.parse(deepLinkValue);
    } else {
      uri = Uri.parse('http://simple.app/$deepLinkValue');
    }

    final isValidUrl = uri.isAbsolute && uri.hasScheme && uri.host.isNotEmpty;

    if (isValidUrl) {
      await handle(uri);
    }
  }

  /// Push Notification Links

  Future<void> handlePushNotificationLink(
    RemoteMessage message, [
    bool isBackground = false,
  ]) async {
    if (isBackground) {
      if (message.data['messageId'] != null) {
        unawaited(logPushNotificationToBD(message.data['messageId'] as String, 1));
      }
    }

    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: _loggerService,
          message: 'handlePushNotificationLink \n\n ${message.data["actionUrl"]}',
        );

    // data: {actionUrl: http://simple.app/action/jw_swap/jw_operation_id/a93fa24f9f544774863e4e7b4c07f3c0},

    if (message.data['actionUrl'] != null) {
      if (lastDeepLink == message.data['actionUrl'] as String) {
        if (lastDeepLinkTime != null && DateTime.now().difference(lastDeepLinkTime!) < const Duration(seconds: 1)) {
          return;
        }
      }
      lastDeepLink = message.data['actionUrl'] as String;
      lastDeepLinkTime = DateTime.now();
      await handle(
        Uri.parse(message.data['actionUrl'] as String),
        messageId: message.data['messageId'] as String? ?? '',
      );
    }
  }

  Future<void> pushCryptoHistory(
    Map<String, String> parameters,
  ) async {
    Future<void> openProfile() async {
      await Future.delayed(const Duration(milliseconds: 100));
      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.home);
      unawaited(sRouter.push(const AccountRouter()));
      await sRouter.push(
        TransactionHistoryRouter(
          jwOperationId: parameters['jw_operation_id'],
          jwOperationPtpManage: parameters[jwOperationPtpManage],
        ),
      );
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await openProfile();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await Future.delayed(const Duration(seconds: 1));
            await openProfile();
          },
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
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
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
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
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
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
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
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      if (showZendesk) {
        await getIt.get<IntercomService>().showMessenger();
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
          func: () async {
            if (showZendesk) {
              await Future.delayed(const Duration(milliseconds: 200));
              await getIt.get<IntercomService>().showMessenger();
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
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
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
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
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
            sRouter.popUntilRoot();
            getIt<BottomBarStore>().setHomeTab(BottomItemType.market);
          }
        } else {
          sRouter.popUntilRoot();
          getIt<BottomBarStore>().setHomeTab(BottomItemType.market);
        }
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
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

  Future<void> pushRateUp(
    Map<String, String> parameters,
  ) async {
    final context = sRouter.navigatorKey.currentContext!;

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await shopRateUpPopup(context, force: true);
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await shopRateUpPopup(context, force: true);
          },
        ),
      );
    }
  }

  Future<void> showEarnScreen(
    Map<String, String> parameters,
  ) async {
    final symbol = parameters[_jwSymbol];

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      final isEarnAvailable = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
          .any((element) => element.id == AssetPaymentProductsEnum.earnProgram);

      if (!isEarnAvailable) return;
      await Future.delayed(const Duration(milliseconds: 100));
      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.earn);

      if (symbol != null) {
        await _openEarnOffersBottomSheet(symbol);
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final isEarnAvailable = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
              (element) => element.id == AssetPaymentProductsEnum.earnProgram,
            );

            if (!isEarnAvailable) return;

            sRouter.popUntilRoot();
            getIt<BottomBarStore>().setHomeTab(BottomItemType.earn);

            if (symbol != null) {
              await _openEarnOffersBottomSheet(symbol);
            }
          },
        ),
      );
    }
  }

  Future<void> _openEarnOffersBottomSheet(String symbol) async {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      symbol,
    );

    final store = EarnStore();

    final currencyOffers = store.filteredOffersGroupedByCurrency[currency.description] ?? [];

    final context = sRouter.navigatorKey.currentContext;
    if (context != null && context.mounted && currencyOffers.isNotEmpty) {
      VoidCallback? contentOnTap;

      await showBasicBottomSheet(
        context: context,
        button: BasicBottomSheetButton(
          title: intl.earn_continue,
          onTap: () {
            contentOnTap?.call();
          },
        ),
        children: [
          OffersOverlayContent(
            offers: currencyOffers,
            currency: currency,
            setParentOnTap: (onTap) {
              contentOnTap = onTap;
            },
          ),
        ],
      );
    }
  }

  Future<void> showTechToast(
    Map<String, String> parameters,
  ) async {
    final paremetr = parameters[_jwParameter];

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
        isError: false,
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            sNotification.showError(
              'Hi, it is tech popup to test deeplink. Parameter: $paremetr',
              id: 1,
              isError: false,
            );
          },
        ),
      );
    }
  }

  Future<void> pushProfileScreen(
    Map<String, String> parameters,
  ) async {
    final symbol = parameters[_jwSymbol];
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      sRouter.popUntilRoot();

      unawaited(sRouter.push(const AccountRouter()));

      await Future.delayed(const Duration(milliseconds: 650));
      await poshToScreenInProfileScreen(symbol);
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final isAccountRouterNow = sRouter.stack.any((rout) => rout.name == AccountRouter.name);
            if (!isAccountRouterNow) {
              unawaited(sRouter.push(const AccountRouter()));
            }
            await Future.delayed(const Duration(milliseconds: 650));
            await poshToScreenInProfileScreen(symbol);
          },
        ),
      );
    }
  }

  Future<void> poshToScreenInProfileScreen(String? pageSympol) async {
    switch (pageSympol) {
      case '1':
        final isPrepaidCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.prepaidCard,
        );

        if (!isPrepaidCardAvaible) return;

        final kycState = getIt.get<KycService>();
        final handler = getIt.get<KycAlertHandler>();

        handler.handle(
          multiStatus: [
            kycState.withdrawalStatus,
          ],
          isProgress: kycState.verificationInProgress,
          currentNavigate: () {
            final context = sRouter.navigatorKey.currentContext;
            if (context != null) {
              showSendTimerAlertOr(
                context: context,
                from: [BlockingType.withdrawal],
                or: () {
                  sRouter.push(const PrepaidCardServiceRouter());
                },
              );
            }
          },
          requiredDocuments: kycState.requiredDocuments,
          requiredVerifications: kycState.requiredVerifications,
        );
      default:
    }
  }

  Future<void> showGetSimpleCard(
    Map<String, String> parameters,
  ) async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      final context = sRouter.navigatorKey.currentContext!;

      final kycState = getIt.get<KycService>();
      final handler = getIt.get<KycAlertHandler>();

      final userInfo = getIt.get<UserInfoService>();
      final isFlowAvaible =
          userInfo.isSimpleCardAvailable && (sSignalRModules.bankingProfileData?.availableCardsCount ?? 0) > 0;

      if (!isFlowAvaible) return;
      handler.handle(
        multiStatus: [
          kycState.depositStatus,
          kycState.tradeStatus,
          kycState.withdrawalStatus,
        ],
        isProgress: kycState.verificationInProgress,
        currentNavigate: () {
          showSendTimerAlertOr(
            context: context,
            from: [
              BlockingType.withdrawal,
              BlockingType.deposit,
              BlockingType.trade,
            ],
            or: () {
              showGetSimpleCardModal(context: context);
            },
          );
        },
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final context = sRouter.navigatorKey.currentContext!;

            final kycState = getIt.get<KycService>();
            final handler = getIt.get<KycAlertHandler>();

            final userInfo = getIt.get<UserInfoService>();
            final isFlowAvaible =
                userInfo.isSimpleCardAvailable && (sSignalRModules.bankingProfileData?.availableCardsCount ?? 0) > 0;

            if (!isFlowAvaible) return;
            handler.handle(
              multiStatus: [
                kycState.depositStatus,
                kycState.tradeStatus,
                kycState.withdrawalStatus,
              ],
              isProgress: kycState.verificationInProgress,
              currentNavigate: () {
                showSendTimerAlertOr(
                  context: context,
                  from: [
                    BlockingType.withdrawal,
                    BlockingType.deposit,
                    BlockingType.trade,
                  ],
                  or: () {
                    showGetSimpleCardModal(context: context);
                  },
                );
              },
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          },
        ),
      );
    }
  }

  Future<void> pushSimpleCardScreen(
    Map<String, String> parameters,
  ) async {
    final cardID = parameters[_jwParameter];
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      final allCards = sSignalRModules.bankingProfileData?.banking?.cards?.where(
            (element) =>
                element.status != AccountStatusCard.inactive && element.status != AccountStatusCard.unsupported,
          ) ??
          [];
      if (allCards.isEmpty) return;
      final card = allCards.firstWhere(
        (card) => card.cardId == cardID,
        orElse: () => allCards.first,
      );
      final simpleCardStore = getIt.get<SimpleCardStore>();
      unawaited(simpleCardStore.initFullCardIn(card.cardId ?? ''));
      await sRouter.push(
        SimpleCardRouter(
          isAddCashAvailable: sSignalRModules.currenciesList
              .where((currency) {
                return currency.assetBalance != Decimal.zero;
              })
              .toList()
              .isNotEmpty,
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final allCards = sSignalRModules.bankingProfileData?.banking?.cards?.where(
                  (element) =>
                      element.status != AccountStatusCard.inactive && element.status != AccountStatusCard.unsupported,
                ) ??
                [];
            if (allCards.isEmpty) return;
            final card = allCards.firstWhere(
              (card) => card.cardId == cardID,
              orElse: () => allCards.first,
            );
            final simpleCardStore = getIt.get<SimpleCardStore>();
            unawaited(simpleCardStore.initFullCardIn(card.cardId ?? ''));
            await sRouter.push(
              SimpleCardRouter(
                isAddCashAvailable: sSignalRModules.currenciesList
                    .where((currency) {
                      return currency.assetBalance != Decimal.zero;
                    })
                    .toList()
                    .isNotEmpty,
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _pushAssetScreen(
    Map<String, String> parameters,
  ) async {
    final jwSymbol = parameters['jw_symbol'];

    Future<void> openWallet() async {
      final currency = sSignalRModules.currenciesList.firstWhereOrNull((e) => e.symbol == jwSymbol);
      final context = sRouter.navigatorKey.currentContext;
      final accountIsActive = sSignalRModules.bankingProfileData?.simple?.account?.status == AccountStatus.active;
      final showState = sSignalRModules.bankingProfileData?.showState == BankingShowState.accountList;

      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.home);

      if (currency != null && context != null && currency.symbol != 'EUR') {
        navigateToWallet(context, currency, isSinglePage: true);
      } else if (currency != null && context != null && currency.symbol == 'EUR' && accountIsActive && showState) {
        navigateToEurWallet(
          context: context,
          currency: currency,
          isSinglePage: true,
        );
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await openWallet();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await openWallet();
          },
        ),
      );
    }
  }

  Future<void> _saveUtmSourse({required String utm}) async {
    final encodedUtm = Uri.decodeFull(utm);
    final storageService = getIt.get<LocalStorageService>();

    final currentUtm = await storageService.getValue(utmSourceKey);

    if (currentUtm == null) {
      await storageService.setString(utmSourceKey, encodedUtm);
    }
  }

  Future<void> _pushMySimpleCoinsScreen(
    Map<String, String> parameters,
  ) async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      final isSimpleCoinAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
        (element) => element.id == AssetPaymentProductsEnum.simpleTapToken,
      );
      if (isSimpleCoinAvaible) {
        sRouter.popUntilRoot();
        getIt<BottomBarStore>().setHomeTab(BottomItemType.home);
        await sRouter.push(const MySimpleCoinsRouter());
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final isSimpleCoinAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
              (element) => element.id == AssetPaymentProductsEnum.simpleTapToken,
            );
            if (isSimpleCoinAvaible) {
              await sRouter.push(const MySimpleCoinsRouter());
            }
          },
        ),
      );
    }
  }

  Future<void> _pushJar(
    Map<String, String> parameters,
  ) async {
    Future<void> func(String? jarId) async {
      unawaited(getIt.get<JarsStore>().refreshJarsStore());
      getIt.get<MyWalletsScrollStore>().scrollToJarTitle();
      if (jarId != null) {
        getIt.get<JarsStore>().setSelectedJarById(jarId);
        await Future.delayed(const Duration(milliseconds: 500));
        if (getIt.get<JarsStore>().selectedJar != null) {
          await getIt<AppRouter>().push(
            JarRouter(
              hasLeftIcon: true,
            ),
          );
        }
      }
    }

    final jarId = parameters[_jwJarId];

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      final isJarAvailable = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
        (element) => element.id == AssetPaymentProductsEnum.jar,
      );
      if (isJarAvailable) {
        sRouter.popUntilRoot();
        getIt<BottomBarStore>().setHomeTab(BottomItemType.home);

        await func(jarId);
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final isJarAvailable = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
              (element) => element.id == AssetPaymentProductsEnum.jar,
            );
            if (isJarAvailable) {
              await func(jarId);
            }
          },
        ),
      );
    }
  }

  Future<void> openMarketSectorScreen(
    Map<String, String> parameters,
  ) async {
    final sectorId = parameters[_jw_sector_id];

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await Future.delayed(const Duration(milliseconds: 100));
      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.market);

      final sector = sSignalRModules.marketSectors.firstWhereOrNull((sector) => sector.id == sectorId);
      if (sector != null) {
        await sRouter.push(
          MarketSectorDetailsRouter(
            sector: sector,
          ),
        );
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            sRouter.popUntilRoot();
            getIt<BottomBarStore>().setHomeTab(BottomItemType.market);

            final sector = sSignalRModules.marketSectors.firstWhereOrNull((sector) => sector.id == sectorId);
            if (sector != null) {
              await sRouter.push(
                MarketSectorDetailsRouter(
                  sector: sector,
                ),
              );
            }
          },
        ),
      );
    }
  }

  Future<void> openCardPreorderTab(
    Map<String, String> parameters,
  ) async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      final isPreorderAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
        (element) => element.id == AssetPaymentProductsEnum.cardPreorder,
      );
      if (isPreorderAvaible) {
        await Future.delayed(const Duration(milliseconds: 100));
        sRouter.popUntilRoot();
        getIt<BottomBarStore>().setHomeTab(BottomItemType.card);
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final isPreorderAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
              (element) => element.id == AssetPaymentProductsEnum.cardPreorder,
            );
            if (isPreorderAvaible) {
              sRouter.popUntilRoot();
              getIt<BottomBarStore>().setHomeTab(BottomItemType.card);
            }
          },
        ),
      );
    }
  }

  Future<void> openCryptoCardTab(
    Map<String, String> parameters,
  ) async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      final isCryptoCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
        (element) => element.id == AssetPaymentProductsEnum.cryptoCard,
      );
      if (isCryptoCardAvaible) {
        await Future.delayed(const Duration(milliseconds: 100));
        sRouter.popUntilRoot();
        getIt<BottomBarStore>().setHomeTab(BottomItemType.cryptoCard);
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final isCryptoCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
              (element) => element.id == AssetPaymentProductsEnum.cryptoCard,
            );
            if (isCryptoCardAvaible) {
              sRouter.popUntilRoot();
              getIt<BottomBarStore>().setHomeTab(BottomItemType.cryptoCard);
            }
          },
        ),
      );
    }
  }
}
