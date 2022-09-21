import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_deposit/action_deposit.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/email_verification/store/email_verification_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_confirm_store.dart';
import 'package:jetwallet/features/currency_withdraw/ui/widgets/withdrawal_confirm.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/about_block/components/clickable_underlined_text.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_apy_portfolio/components/earn_bottom_sheet/components/earn_bottom_sheet_container.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_apy_portfolio/components/earn_bottom_sheet/earn_bottom_sheet.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_confirm_store.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_confirm.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/show_start_earn_options.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import 'local_storage_service.dart';

/// Parameters
const _code = 'jw_code';
const _command = 'jw_command';
const _operationId = 'jw_operation_id';
const _email = 'jw_email';
// when parameters come in "/" format as part of the link
const _action = 'action';

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

enum SourceScreen {
  bannerOnMarket,
  bannerOnRewards,
  accountScreen,
}

class DeepLinkService {
  DeepLinkService();

  final _logger = Logger('');

  void handle(Uri link, [SourceScreen? source]) {
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
    } else if (command == _recurringBuyStart) {
      _recurringBuyStartCommand();
    } else if (command == _highYield) {
      _highYieldStartCommand();
    } else {
      _logger.log(Level.INFO, 'Deep link is undefined: $link');
    }
  }

  void _highYieldStartCommand() {
    sRouter.navigate(
      const HomeRouter(
        children: [
          EarnRouter(),
        ],
      ),
    );
  }

  void _recurringBuyStartCommand() {
    final context = sRouter.navigatorKey.currentContext!;

    showBuyAction(
      context: context,
      fromCard: false,
      shouldPop: false,
      showRecurring: true,
    );
  }

  Future<void> _depositStartCommand(SourceScreen? source) async {
    final appStore = getIt.get<AppStore>();

    if (source == SourceScreen.bannerOnMarket) {
      await sRouter.push(const RewardsRouter());
    } else if (source == SourceScreen.bannerOnRewards) {
      appStore.setOpenBottomMenu(true);

      await sRouter.pop();
    }
  }

  void _tradingStartCommand(SourceScreen? source) {
    if (source == SourceScreen.bannerOnMarket) {
      sRouter.push(const RewardsRouter());
    } else if (source == SourceScreen.bannerOnRewards) {
      sRouter.navigate(
        const HomeRouter(
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
    getIt.get<LogoutService>().logout();

    sRouter.push(
      SingInRouter(
        email: parameters[_email],
      ),
    );
  }

  void _confirmWithdrawCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;
    final notifier = WithdrawalConfirmStore(withdrawalModel);

    notifier.updateCode(code, id);
  }

  void _confirmSendByPhoneCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;
    final notifier = SendByPhoneConfirmStore(currencyModel);

    notifier.updateCode(code, id);
  }

  void _inviteFriendCommand(SourceScreen? source) {
    final context = sRouter.navigatorKey.currentContext!;
    final referralInfo = sSignalRModules.referralInfo;
    final logoSize = MediaQuery.of(context).size.width * 0.2;

    sAnalytics.clickMarketBanner(
      MarketBannerSource.inviteFriend.name,
      MarketBannerAction.open,
    );

    if (source == SourceScreen.bannerOnMarket) {
      sAnalytics.inviteFriendView(Source.marketBanner);
    } else if (source == SourceScreen.bannerOnRewards) {
      sAnalytics.inviteFriendView(Source.rewards);
    } else if (source == SourceScreen.accountScreen) {
      sAnalytics.inviteFriendView(Source.accountScreen);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return EarnBottomSheetContainer(
          removePinnedPadding: true,
          horizontalPinnedPadding: 0,
          scrollable: true,
          color: Colors.white,
          pinned: SReferralInvitePinned(
            child: SPaddingH24(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 203.0,
                    child: Baseline(
                      baseline: 34.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        referralInfo.title,
                        maxLines: 3,
                        style: sTextH2Style,
                      ),
                    ),
                  ),
                  if (referralInfo.descriptionLink.isNotEmpty)
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Baseline(
                        baseline: 94,
                        baselineType: TextBaseline.alphabetic,
                        child: ClickableUnderlinedText(
                          text: intl.deepLinkService_readMore,
                          onTap: () {
                            launchURL(
                              context,
                              referralInfo.descriptionLink,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          pinnedSmall: Stack(
            children: [
              SizedBox(
                height: 115,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: RichText(
                        text: TextSpan(
                          text: referralInfo.title,
                          style: sTextH5Style.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 24.0,
                right: 24.0,
                child: SIconButton(
                  onTap: () => Navigator.pop(context),
                  defaultIcon: const SErasePressedIcon(),
                  pressedIcon: const SEraseMarketIcon(),
                ),
              ),
            ],
          ),
          pinnedBottom: SReferralInviteBottomPinned(
            text: intl.deepLinkService_share,
            onShare: () {
              try {
                Share.share(referralInfo.referralLink);
              } catch (e) {}
            },
          ),
          expandedHeight: 333,
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
      },
    );
  }

  Future<void> _referralRedirectCommand(Map<String, String> parameters) async {
    final storage = sLocalStorageService;
    final deviceInfo = sDeviceInfo.model;
    final referralCode = parameters[_code];

    await storage.setString(referralCodeKey, referralCode);
    await checkInitAppFBAnalytics(storage, deviceInfo);
  }

  void _earnLandingCommand(SourceScreen? source) {
    final context = sRouter.navigatorKey.currentContext!;

    sAnalytics.clickMarketBanner(
      MarketBannerSource.earn.name,
      MarketBannerAction.open,
    );

    showStartEarnBottomSheet(
      context: context,
      onTap: (CurrencyModel currency) {
        sRouter.pop();
        sAnalytics.earnDetailsView(currency.description);

        showStartEarnOptions(
          currency: currency,
        );
      },
    );

    if (source == SourceScreen.bannerOnMarket) {
      sAnalytics.earnProgramView(Source.marketBanner);
    } else if (source == SourceScreen.bannerOnRewards) {
      sAnalytics.earnProgramView(Source.rewards);
    }
  }
}
