import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../app/screens/navigation/provider/navigation_stpod.dart';
import '../../app/screens/navigation/provider/open_bottom_menu_spod.dart';
import '../../app/screens/portfolio/view/components/empty_portfolio/components/earn_bottom_sheet/components/earn_bottom_sheet_container.dart';
import '../../app/screens/portfolio/view/components/empty_portfolio/components/earn_bottom_sheet/earn_bottom_sheet.dart';
import '../../app/shared/components/show_start_earn_options.dart';
import '../../app/shared/features/actions/action_buy/action_buy.dart';
import '../../app/shared/features/actions/action_deposit/action_deposit.dart';
import '../../app/shared/features/currency_withdraw/notifier/withdrawal_confirm_notifier/withdrawal_confirm_notipod.dart';
import '../../app/shared/features/currency_withdraw/view/screens/withdrawal_confirm.dart';
import '../../app/shared/features/kyc/notifier/kyc/kyc_notipod.dart';
import '../../app/shared/features/market_details/view/components/about_block/components/clickable_underlined_text.dart';
import '../../app/shared/features/rewards/view/rewards.dart';
import '../../app/shared/features/send_by_phone/notifier/send_by_phone_confirm_notifier/send_by_phone_confirm_notipod.dart';
import '../../app/shared/features/send_by_phone/view/screens/send_by_phone_confirm.dart';
import '../../app/shared/models/currency_model.dart';
import '../../auth/screens/email_verification/notifier/email_verification_notipod.dart';
import '../../auth/screens/forgot_password/notifier/confirm_password_reset/confirm_password_reset_notipod.dart';
import '../../auth/screens/forgot_password/view/confirm_password_reset.dart';
import '../../auth/screens/login/login.dart';
import '../../router/notifier/startup_notifier/authorized_union.dart';
import '../../router/notifier/startup_notifier/startup_notipod.dart';
import '../helpers/launch_url.dart';
import '../helpers/navigator_push.dart';
import '../notifiers/logout_notifier/logout_notipod.dart';
import '../providers/referral_info_pod.dart';
import '../providers/service_providers.dart';
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
const _forgotPassword = 'ForgotPassword';
const _confirmWithdraw = 'VerifyWithdrawal';
const _confirmSendByPhone = 'VerifyTransfer';
const _inviteFriend = 'InviteFriend';
const _referralRedirect = 'ReferralRedirect';
const _depositStart = 'DepositStart';
const _kycVerification = 'KycVerification';
const _tradingStart = 'TradingStart';
const _earnLanding = 'EarnLanding';
const _recurringBuyStart = 'RecurringBuyStart';

enum SourceScreen {
  bannerOnMarket,
  bannerOnRewards,
  accountScreen,
}

class DeepLinkService {
  DeepLinkService(this.read);

  final Reader read;

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
          for (var i = 0; i < names.length; i++) names[i]: values[i]
        };
      }
    }

    final command = parameters[_command];

    if (command == _confirmEmail) {
      _confirmEmailCommand(parameters);
    } else if (command == _login) {
      _loginCommand(parameters);
    } else if (command == _forgotPassword) {
      _forgotPasswordCommand(parameters);
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
    } else {
      _logger.log(Level.INFO, 'Deep link is undefined: $link');
    }
  }

  void _recurringBuyStartCommand() {
    final context = read(sNavigatorKeyPod).currentContext!;

    showBuyAction(
      context: context,
      fromCard: false,
      shouldPop: false,
      showRecurring: true,
    );
  }

  Future<void> _depositStartCommand(SourceScreen? source) async {
    final context = read(sNavigatorKeyPod).currentContext!;
    final openBottomMenu = read(openBottomMenuSpod);

    if (source == SourceScreen.bannerOnMarket) {
      navigatorPush(context, const Rewards());
    } else if (source == SourceScreen.bannerOnRewards) {
      openBottomMenu.state = true;
      Navigator.pop(context);
    }
  }

  void _tradingStartCommand(SourceScreen? source) {
    final context = read(sNavigatorKeyPod).currentContext!;

    if (source == SourceScreen.bannerOnMarket) {
      navigatorPush(context, const Rewards());
    } else if (source == SourceScreen.bannerOnRewards) {
      final ctx = read(sNavigatorKeyPod).currentContext!;
      final navigation = read(navigationStpod);
      navigation.state = 0;
      Navigator.pop(ctx);
    }
  }

  void _kycVerificationCommand() {
    final kycState = read(kycNotipod);
    final context = read(sNavigatorKeyPod).currentContext!;
    final kycAlertHandler = read(
      kycAlertHandlerPod(context),
    );

    kycAlertHandler.handle(
      status: kycState.depositStatus,
      kycVerified: kycState,
      isProgress: kycState.verificationInProgress,
      currentNavigate: () => showDepositAction(context),
    );
  }

  void _confirmEmailCommand(Map<String, String> parameters) {
    if (read(startupNotipod).authorized is EmailVerification) {
      final notifier = read(emailVerificationNotipod.notifier);

      notifier.updateCode(parameters[_code]);
    }
  }

  void _loginCommand(Map<String, String> parameters) {
    read(logoutNotipod.notifier).logout();

    navigatorPush(
      read(sNavigatorKeyPod).currentContext!,
      Login(
        email: parameters[_email],
      ),
    );
  }

  void _forgotPasswordCommand(Map<String, String> parameters) {
    final notifier = read(confirmPasswordResetNotipod(email).notifier);

    notifier.updateCode(parameters[_code]);
  }

  void _confirmWithdrawCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;
    final notifier = read(withdrawalConfirmNotipod(withdrawalModel).notifier);

    notifier.updateCode(code, id);
  }

  void _confirmSendByPhoneCommand(Map<String, String> parameters) {
    final id = parameters[_operationId]!;
    final code = parameters[_code]!;
    final notifier = read(sendByPhoneConfirmNotipod(currencyModel).notifier);

    notifier.updateCode(code, id);
  }

  void _inviteFriendCommand(SourceScreen? source) {
    final context = read(sNavigatorKeyPod).currentContext!;
    final referralInfo = read(referralInfoPod);

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
                          text: 'Read more',
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
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const SErasePressedIcon(),
                ),
              ),
            ],
          ),
          pinnedBottom: SReferralInviteBottomPinned(
            onShare: () {
              Share.share(referralInfo.referralLink);
            },
          ),
          expandedHeight: 333,
          children: [
            SReferralInviteBody(
              primaryText: referralInfo.title,
              referralLink: referralInfo.referralLink,
              conditions: referralInfo.referralTerms,
              showReadMore: referralInfo.descriptionLink.isNotEmpty,
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

  void _referralRedirectCommand(Map<String, String> parameters) {
    final storage = read(localStorageServicePod);
    final referralCode = parameters[_code];

    storage.setString(referralCodeKey, referralCode);
  }

  void _earnLandingCommand(SourceScreen? source) {
    final context = read(sNavigatorKeyPod).currentContext!;

    sAnalytics.clickMarketBanner(
      MarketBannerSource.earn.name,
      MarketBannerAction.open,
    );

    showStartEarnBottomSheet(
      context: context,
      onTap: (CurrencyModel currency) {
        Navigator.pop(context);
        sAnalytics.earnDetailsView(currency.description);
        showStartEarnOptions(
          currency: currency,
          read: read,
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
