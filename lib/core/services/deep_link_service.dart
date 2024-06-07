// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/auth/email_verification/store/email_verification_store.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/send_gift/widgets/share_gift_result_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_store.dart';
import 'package:jetwallet/features/simple_card/ui/widgets/card_options.dart';
import 'package:jetwallet/features/withdrawal/model/withdrawal_confirm_model.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:logger/logger.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import 'local_storage_service.dart';
import 'remote_config/models/remote_config_union.dart';
import 'simple_networking/simple_networking.dart';
import 'user_info/user_info_service.dart';

/// Parameters
const _code = 'jw_code';
const _command = 'jw_command';
const _operationId = 'jw_operation_id';
const _email = 'jw_email';
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
    final utmSource = parameters[_utmSource];

    if (utmSource != null) {
      _saveUtmSourse(utm: utmSource);
    }

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
    } else if (command == jw_gift_incoming) {
      //just open the application
    } else if (command == jw_gift_remind) {
      pushRemindGiftBottomSheet(parameters);
    } else if (command == _marketsScreen) {
      pushMarketsScreen(parameters);
    } else if (command == _jwKycBanned) {
      pushDocumentNotVerified(parameters);
    } else if (command == _rateUpCommand) {
      pushRateUp(parameters);
    } else if (command == _earnScreen) {
      showEarnScreen(parameters);
    } else if (command == _techScreen) {
      showTechToast(parameters);
    } else if (command == _profile_screen) {
      pushProfileScreen(parameters);
    } else if (command == _get_simple_card) {
      showGetSimpleCard(parameters);
    } else if (command == _card_screen) {
      pushSimpleCardScreen(parameters);
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

      await sRouter.maybePop();
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

  Future<void> _inviteFriendCommand() async {
    Future<void> openRewards() async {
      if (getIt.get<AppStore>().authStatus == const AuthorizationUnion.authorized() &&
          (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
              .where((element) => element.id == AssetPaymentProductsEnum.rewardsOnboardingProgram)
              .isNotEmpty) {
        sRouter.popUntilRoot();
        getIt<BottomBarStore>().setHomeTab(BottomItemType.rewards);
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
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

  Future<void> pushRateUp(
    Map<String, String> parameters,
  ) async {
    final context = sRouter.navigatorKey.currentContext!;

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
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
        getIt.get<AppStore>().authorizedStatus is Home) {
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
            final isEarnAvailable = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
                .any((element) => element.id == AssetPaymentProductsEnum.earnProgram);

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
      sShowBasicModalBottomSheet(
        context: context,
        scrollable: true,
        children: [
          OffersOverlayContent(
            offers: currencyOffers,
            currency: currency,
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
        getIt.get<AppStore>().authorizedStatus is Home) {
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
        getIt.get<AppStore>().authorizedStatus is Home) {
      final isAccountRouterNow = sRouter.stack.any((rout) => rout.name == AccountRouter.name);
      if (!isAccountRouterNow) {
        unawaited(sRouter.push(const AccountRouter()));
      }
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
        final isPrepaidCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
            .any((element) => element.id == AssetPaymentProductsEnum.prepaidCard);

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
        getIt.get<AppStore>().authorizedStatus is Home) {
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
              showCardOptions(context);
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
                    showCardOptions(context);
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
        getIt.get<AppStore>().authorizedStatus is Home) {
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

  Future<void> _saveUtmSourse({required String utm}) async {
    final encodedUtm = Uri.decodeFull(utm);
    final storageService = getIt.get<LocalStorageService>();

    final currentUtm = await storageService.getValue(utmSourceKey);

    if (currentUtm == null) await storageService.setString(utmSourceKey, encodedUtm);
  }
}
