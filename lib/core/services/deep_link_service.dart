import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/account/account_screen.dart';
import 'package:jetwallet/features/actions/action_deposit/action_deposit.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/auth/email_verification/store/email_verification_store.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_apy_portfolio/components/earn_bottom_sheet/earn_bottom_sheet.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_confirm_store.dart';
import 'package:jetwallet/features/withdrawal/model/withdrawal_confirm_model.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/show_start_earn_options.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:logger/logger.dart';

import 'local_storage_service.dart';
import 'notification_service.dart';
import 'remote_config/models/remote_config_union.dart';

/// Parameters
const _code = 'jw_code';
const _command = 'jw_command';
const _operationId = 'jw_operation_id';
const _email = 'jw_email';
// when parameters come in "/" format as part of the link
const _action = 'action';
const _jw_nft_collection_id = 'jw_nft_collection_id';
const _jw_nft_token_symbol = 'jw_nft_token_symbol';
const jw_promo_code = 'jw_promo_code';

const jw_deposit_successful = 'jw_deposit_successful';
const jw_support_page = 'jw_support_page';
const jw_kyc_documents_declined = 'jw_kyc_documents_declined';

/// Commands
const _confirmEmail = 'ConfirmEmail';
const _login = 'Login';
const _confirmWithdraw = 'VerifyWithdrawal';
const _confirmSendByPhone = 'VerifyTransfer';
const _inviteFriend = 'InviteFriend';
const _referralRedirect = 'ReferralRedirect';
const _depositStart = 'DepositStart';
const _kycVerification = 'KycVerification';
const _tradingStart = 'TradingStart';
const _earnLanding = 'EarnLanding';
const _recurringBuyStart = 'RecurringBuyStart';
const _highYield = 'HighYield';

const _NFTmarket = 'NFT_market';
const _NFTcollection = 'NFT_collection';
const _NFTtoken = 'NFT_token';

// Push Notification

const _jwSwap = 'jw_operation_history';
const _jwTransferByPhoneSend = 'jw_transfer_by_phone_send';
const _jwKycDocumentsApproved = 'jw_kyc_documents_approved';
const _jwKycDocumentsDeclined = 'jw_kyc_documents_declined';
const _jwKycBanned = 'jw_kyc_banned';
const _jwCrypto_withdrawal_decline = 'jw_crypto_withdrawal_decline';

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

    if (command == _confirmEmail) {
      _confirmEmailCommand(parameters);
    } else if (command == _login) {
      _loginCommand(parameters);
    } else if (command == _confirmWithdraw) {
      _confirmWithdrawCommand(parameters);
    } else if (command == _confirmSendByPhone) {
      _confirmSendByPhoneCommand(parameters);
    } else if (command == _inviteFriend) {
      _inviteFriendCommand(source);
    } else if (command == _referralRedirect) {
      _referralRedirectCommand(parameters);
    } else if (command == _earnLanding) {
      _earnLandingCommand(source);
    } else if (command == _kycVerification) {
      _kycVerificationCommand();
    } else if (command == _tradingStart) {
      _tradingStartCommand(source);
    } else if (command == _depositStart) {
      _depositStartCommand(source);
    } else if (command == _jwSwap) {
      pushCryptoHistory(parameters);
    } else if (command == _jwTransferByPhoneSend) {
      pushCryptoWithdrawal(parameters);
    } else if (command == _jwKycDocumentsApproved) {
      pushKycDocumentsApproved();
    } else if (command == _jwKycDocumentsDeclined) {
      pushKycDocumentsDeclined();
    } else if (command == _jwKycBanned) {
      pushKycDocumentsApproved();
    } else if (command == _jwCrypto_withdrawal_decline) {
      pushWithrawalDecline(parameters);
    } else if (command == jw_deposit_successful) {
      pushDepositSuccess(parameters);
    } else if (command == jw_support_page) {
      pushSupportPage(parameters);
    } else if (command == jw_kyc_documents_declined) {
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

  void _tradingStartCommand(SourceScreen? source) {
    if (source == SourceScreen.bannerOnMarket) {
      sRouter.push(RewardsRouter(actualRewards: const []));
    } else if (source == SourceScreen.bannerOnRewards) {
      sRouter.navigate(
        HomeRouter(
          children: [MarketRouter()],
        ),
      );
      sRouter.pop();
    }
  }

  void _kycVerificationCommand() {
    final kycState = getIt.get<KycService>();
    final context = sRouter.navigatorKey.currentContext!;
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    kycAlertHandler.handle(
      status: kycState.depositStatus,
      isProgress: kycState.verificationInProgress,
      currentNavigate: () => showDepositAction(context),
      requiredVerifications: kycState.requiredVerifications,
      requiredDocuments: kycState.requiredDocuments,
    );
  }

  void _confirmEmailCommand(Map<String, String> parameters) {
    getIt.get<EmailVerificationStore>().updateCode(
          parameters[_code],
        );
  }

  void _loginCommand(Map<String, String> parameters) {
    getIt.get<LogoutService>().logout(
          'DEEPLINK logincommand',
          callbackAfterSend: () {},
        );

    sRouter.push(
      SingInRouter(
        email: parameters[_email],
      ),
    );
  }

  void _confirmWithdrawCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;

    //getIt.get<WithdrawalConfirmStore>().updateCode(code, id);

    getIt
        .get<EventBus>()
        .fire(WithdrawalConfirmModel(code: code, operationID: id));
  }

  void _confirmSendByPhoneCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;

    final notifier = getIt.get<SendByPhoneConfirmStore>();

    notifier.updateCode(code, id, isDeepLink: true);
  }

  void _inviteFriendCommand(SourceScreen? source) {
    final context = sRouter.navigatorKey.currentContext!;
    final referralInfo = sSignalRModules.referralInfo;
    final logoSize = MediaQuery.of(context).size.width * 0.2;

    sShowBasicModalBottomSheet(
      context: context,
      removePinnedPadding: true,
      horizontalPinnedPadding: 0,
      scrollable: true,
      color: Colors.white,
      pinned: SPaddingH24(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 147,
              child: Baseline(
                baseline: 34.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  referralInfo.title,
                  maxLines: 3,
                  style: sTextH3Style,
                ),
              ),
            ),
            if (referralInfo.descriptionLink.isNotEmpty)
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    ClickableUnderlinedText(
                      text: intl.deepLinkService_readMore,
                      onTap: () {
                        sRouter.push(
                          InfoWebViewRouter(
                            link: referralInfo.descriptionLink,
                            title: intl.rewards_rewards,
                          ),
                        );
                      },
                    ),
                    const SpaceH10(),
                  ],
                ),
              ),
          ],
        ),
      ),
      pinnedBottom: Column(
        children: [
          SAddressFieldWithCopy(
            afterCopyText: intl.deepLinkService_referralLinkCopied,
            value: referralInfo.referralLink,
            header: intl.deepLinkService_referralLink,
            then: () {
              sNotification.showError(intl.copy_message, id: 1, isError: false);
            },
          ),
          SReferralInviteBottomPinned(
            text: intl.deepLinkService_share,
            onShare: () {
              try {
                Share.share(referralInfo.referralLink);
              } catch (e) {}
            },
          ),
        ],
      ),
      children: [
        SReferralInviteBody(
          primaryText: referralInfo.title,
          referralLink: referralInfo.referralLink,
          conditions: referralInfo.referralTerms,
          showReadMore: referralInfo.descriptionLink.isNotEmpty,
          copiedText: intl.deepLinkService_referralLinkCopied,
          referralText: intl.deepLinkService_referralLink,
          logoSize: logoSize,
          onReadMoreTap: () {
            launchURL(
              context,
              referralInfo.descriptionLink,
            );
          },
        ),
      ],
    );
  }

  Future<void> _referralRedirectCommand(Map<String, String> parameters) async {
    try {
      final storage = sLocalStorageService;
      final deviceInfo = sDeviceInfo.model;
      final referralCode = parameters[_code];

      await storage.setString(referralCodeKey, referralCode);
      await checkInitAppFBAnalytics(storage, deviceInfo);

      await getIt.get<ReferallCodeStore>().init();
    } catch (e) {}
  }

  void _earnLandingCommand(SourceScreen? source) {
    final context = sRouter.navigatorKey.currentContext!;

    showStartEarnBottomSheet(
      context: context,
      onTap: (CurrencyModel currency) {
        sRouter.pop();

        showStartEarnOptions(
          currency: currency,
        );
      },
    );
  }

  /// Push Notification Links

  Future<void> handlePushNotificationLink(RemoteMessage message) async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: _loggerService,
          message:
              'handlePushNotificationLink \n\n ${message.data["actionUrl"]}',
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
    if (currency.isAssetBalanceEmpty && !currency.isPendingDeposit) {
      if (getIt.isRegistered<AppStore>() &&
          getIt.get<AppStore>().remoteConfigStatus is Success &&
          getIt.get<AppStore>().authorizedStatus is Home) {
        await sRouter.push(
          EmptyWalletRouter(
            currency: currency,
          ),
        );
      } else {
        getIt<RouteQueryService>().addToQuery(
          RouteQueryModel(
            action: RouteQueryAction.push,
            query: EmptyWalletRouter(
              currency: currency,
            ),
          ),
        );
      }
    } else {
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
  }

  Future<void> pushKycDocumentsApproved() async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      getIt.get<AppStore>().setHomeTab(1);
      if (getIt.get<AppStore>().tabsRouter != null) {
        getIt.get<AppStore>().tabsRouter!.setActiveIndex(1);
      }

      sRouter.popUntilRoot();

      await sRouter.replaceAll(
        [
          HomeRouter(
            children: [
              MarketRouter(
                initIndex: 1,
              ),
            ],
          ),
        ],
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          action: RouteQueryAction.replace,
          query: HomeRouter(
            children: [
              MarketRouter(initIndex: 1),
            ],
          ),
          func: () {
            getIt.get<AppStore>().setHomeTab(1);
          },
        ),
      );
    }
  }

  Future<void> pushKycDocumentsDeclined() async {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      await sRouter.push(
        ChooseDocumentsRouter(
          headerTitle: 'Verify your identity',
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          action: RouteQueryAction.push,
          query: ChooseDocumentsRouter(
            headerTitle: 'Verify your identity',
          ),
        ),
      );
    }
  }

  Future<void> pushWithrawalDecline(
    Map<String, String> parameters,
  ) async {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      parameters['asset'] ?? 'BTC',
    );

    //navigateToWallet
    if (currency.isAssetBalanceEmpty && !currency.isPendingDeposit) {
      if (getIt.isRegistered<AppStore>() &&
          getIt.get<AppStore>().remoteConfigStatus is Success &&
          getIt.get<AppStore>().authorizedStatus is Home) {
        await sRouter.push(
          EmptyWalletRouter(
            currency: currency,
          ),
        );
      } else {
        getIt<RouteQueryService>().addToQuery(
          RouteQueryModel(
            action: RouteQueryAction.push,
            query: EmptyWalletRouter(
              currency: currency,
            ),
          ),
        );
      }
    } else {
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
  }

  Future<void> pushDepositSuccess(
    Map<String, String> parameters,
  ) async {
    if (parameters['jw_operation_id'] == null) return;

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      parameters['jw_operation_id']!,
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
          query: WalletRouter(
            currency: currency,
          ),
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
      await sRouter.push(
        CrispRouter(
          welcomeText: intl.crispSendMessage_hi,
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          action: RouteQueryAction.push,
          query: CrispRouter(
            welcomeText: intl.crispSendMessage_hi,
          ),
        ),
      );
    }
  }

  Future<void> pushDocumentNotVerified(
    Map<String, String> parameters,
  ) async {
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    kycAlertHandler.handle(
      status: kycState.depositStatus,
      isProgress: kycState.verificationInProgress,
      currentNavigate: () => sRouter.push(
        const AccountRouter(),
      ),
      requiredVerifications: kycState.requiredVerifications,
      requiredDocuments: kycState.requiredDocuments,
    );
  }
}
