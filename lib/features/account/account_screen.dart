import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/account/widgets/account_banner_list.dart';
import 'package:jetwallet/features/account/widgets/account_button_widget.dart';
import 'package:jetwallet/features/account/widgets/log_out_option.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/prepaid_card/widgets/prepaid_card_profile_banner.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

import '../../core/services/deep_link_service.dart';
import '../../core/services/signal_r/signal_r_service_new.dart';

import '../../utils/constants.dart';

@RoutePage(name: 'AccountRouter')
class AccountScreen extends StatefulObserverWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  int debugTapCounter = 0;

  // for analytic
  GlobalHistoryTab historyTab = GlobalHistoryTab.all;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final flavor = flavorService();

    final logout = getIt.get<LogoutService>();

    final authInfo = getIt.get<AppStore>().authState;
    final userInfo = sUserInfo;
    final userInfoN = getIt.get<UserInfoService>();
    userInfoN.initBiometricStatus();

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final deepLinkService = getIt.get<DeepLinkService>();
    final marketCampaigns = sSignalRModules.marketCampaigns
        .where(
          (element) => element.deepLink.contains('InviteFriend'),
        )
        .toList();

    final isPrepaidCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
      (element) => element.id == AssetPaymentProductsEnum.prepaidCard,
    );

    return Material(
      color: colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SimpleAccountCategoryHeader(
            onIconTap: () {
              if (debugTapCounter >= 30) {
                sRouter.push(
                  const DebugInfoRouter(),
                );
                setState(() {
                  debugTapCounter = 0;
                });
              } else {
                setState(() {
                  debugTapCounter++;
                });
              }
            },
            userEmail: authInfo.email,
            userFirstName: userInfo.firstName,
            userLastName: userInfo.lastName,
            showUserName: userInfo.firstName.isNotEmpty && userInfo.lastName.isNotEmpty,
            isVerified: checkKycPassed(
                  kycState.depositStatus,
                  kycState.tradeStatus,
                  kycState.withdrawalStatus,
                ) &&
                !kycState.isSimpleKyc,
            icon: Image.asset(
              verifiedAsset,
              width: 16,
              height: 16,
            ),
            iconText: intl.account_verified,
          ),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                AccountBannerList(
                  kycRequired: checkKycRequired(
                        kycState.depositStatus,
                        kycState.tradeStatus,
                        kycState.withdrawalStatus,
                      ) ||
                      (kycState.isSimpleKyc && kycState.earlyKycFlowAllowed),
                  kycBlocked: checkKycBlocked(
                    kycState.depositStatus,
                    kycState.tradeStatus,
                    kycState.withdrawalStatus,
                  ),
                  verificationInProgress: kycState.inVerificationProgress,
                  phoneVerified: userInfo.phoneVerified,
                  onChatBannerTap: () async {
                    if (showZendesk) {
                      await getIt.get<IntercomService>().showMessenger();
                    } else {
                      await sRouter.push(
                        CrispRouter(
                          welcomeText: intl.crispSendMessage_hi,
                        ),
                      );
                    }
                  },
                  onKycBannerTap: () {
                    final isDepositAllow = kycState.depositStatus != kycOperationStatus(KycStatus.allowed);
                    final isWithdrawalAllow = kycState.withdrawalStatus != kycOperationStatus(KycStatus.allowed);

                    kycAlertHandler.handleKycBanner(
                      status: isDepositAllow
                          ? kycState.depositStatus
                          : isWithdrawalAllow
                              ? kycState.withdrawalStatus
                              : kycState.tradeStatus,
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () {},
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications: kycState.requiredVerifications,
                      customBlockerText: intl.profile_kyc_bloked_alert,
                    );
                  },
                ),
                if (isPrepaidCardAvaible)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 24, right: 24),
                    child: PrepaidCardProfileBanner(),
                  ),
                Column(
                  children: <Widget>[
                    AccountButtonWidget(
                      title: intl.account_profileDetails,
                      icon: const SProfileDetailsIcon(),
                      onTap: () {
                        sRouter.push(
                          const ProfileDetailsRouter(),
                        );
                      },
                    ),
                    if (marketCampaigns.isNotEmpty)
                      AccountButtonWidget(
                        title: intl.onboarding_inviteFriends,
                        icon: const SInviteFriendsIcon(),
                        onTap: () {
                          deepLinkService.handle(
                            Uri.parse(marketCampaigns[0].deepLink),
                            source: SourceScreen.bannerOnRewards,
                          );
                        },
                      ),
                    AccountButtonWidget(
                      title: intl.account_security,
                      icon: const SSecurityIcon(),
                      onTap: () {
                        sRouter.push(
                          const AccountSecurityRouter(),
                        );
                      },
                    ),
                    AccountButtonWidget(
                      title: intl.account_paymentMethods,
                      icon: SActionDepositIcon(
                        color: colors.black,
                      ),
                      onTap: () {
                        sRouter.push(
                          const PaymentMethodsRouter(),
                        );
                      },
                    ),
                    AccountButtonWidget(
                      title: intl.account_transactionHistory,
                      icon: const SIndexHistoryIcon(),
                      onTap: () {
                        historyTab = GlobalHistoryTab.all;
                        sRouter.push(
                          TransactionHistoryRouter(
                            onTabChanged: (index) {
                              final result = index == 0 ? GlobalHistoryTab.all : GlobalHistoryTab.pending;
                              setState(() {
                                historyTab = result;
                              });
                            },
                          ),
                        ).then(
                          (value) {
                            sAnalytics.tapOnTheButtonBackOnGlobalTransactionHistoryScreen(
                              globalHistoryTab: historyTab,
                            );
                          },
                        );
                      },
                    ),
                    AccountButtonWidget(
                      title: intl.account_support,
                      icon: const SSupportIcon(),
                      onTap: () async {
                        if (showZendesk) {
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
                    AccountButtonWidget(
                      title: intl.account_helpCenter,
                      icon: const SQuestionIcon(),
                      onTap: () {
                        sRouter.push(
                          WebViewRouter(
                            link: faqLink,
                            title: intl.helpCenterWebView,
                          ),
                        );
                      },
                    ),
                    AccountButtonWidget(
                      title: intl.account_aboutUs,
                      icon: const SAboutUsIcon(),
                      onTap: () {
                        sRouter.push(
                          const AboutUsRouter(),
                        );
                      },
                    ),
                    if (flavor == Flavor.dev || flavor == Flavor.stage)
                      AccountButtonWidget(
                        title: intl.account_debugInfo,
                        icon: const SInfoIcon(),
                        onTap: () {
                          sRouter.push(
                            const DebugInfoRouter(),
                          );
                        },
                      ),
                    LogOutOption(
                      name: intl.log_out,
                      onTap: () => logout.logout(
                        'account logout',
                        callbackAfterSend: () {},
                      ),
                    ),
                  ],
                ),
                const SpaceH42(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
