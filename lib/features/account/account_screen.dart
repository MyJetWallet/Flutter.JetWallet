import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/core/services/zendesk_support_service/zendesk_service.dart';
import 'package:jetwallet/features/account/widgets/account_banner_list.dart';
import 'package:jetwallet/features/account/widgets/log_out_option.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;
    final flavor = flavorService();

    final logout = getIt.get<LogoutService>();

    final authInfo = getIt.get<AppStore>().authState;
    final userInfo = sUserInfo;
    final userInfoN = getIt.get<UserInfoService>();
    userInfoN.initBiometricStatus();

    //TODO REFACTOR
    //final cardFailed = useProvider(bottomNavigationNotipod);

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final deepLinkService = getIt.get<DeepLinkService>();
    final marketCampaigns = sSignalRModules.marketCampaigns
        .where(
          (element) => element.deepLink.contains('InviteFriend'),
        )
        .toList();

    /*
    logout.union.when(
      result: (error, st) {
        if (error != null) {
          showPlainSnackbar(context, '$error');
        }
      },
      loading: () {},
    );
    */

    return Material(
      color: colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SPaddingH24(
            child: SimpleAccountCategoryHeader(
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
              ),
              icon: Image.asset(
                verifiedAsset,
                width: 16,
                height: 16,
              ),
              iconText: intl.account_verified,
            ),
          ),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                AccountBannerList(
                  kycPassed: checkKycPassed(
                    kycState.depositStatus,
                    kycState.tradeStatus,
                    kycState.withdrawalStatus,
                  ),
                  kycBlocked: checkKycBlocked(
                    kycState.depositStatus,
                    kycState.tradeStatus,
                    kycState.withdrawalStatus,
                  ),
                  verificationInProgress: kycState.inVerificationProgress,
                  twoFaEnabled: true,
                  phoneVerified: userInfo.phoneVerified,
                  onTwoFaBannerTap: () {
                    sRouter.push(const SmsAuthenticatorRouter());
                  },
                  onChatBannerTap: () async {
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
                  onKycBannerTap: () {
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
                      customBlockerText: intl.profile_kyc_bloked_alert,
                    );
                  },
                ),
                Column(
                  children: <Widget>[
                    SimpleAccountCategoryButton(
                      title: intl.account_profileDetails,
                      icon: const SProfileDetailsIcon(),
                      isSDivider: true,
                      onTap: () {
                        sRouter.push(
                          const ProfileDetailsRouter(),
                        );
                      },
                    ),
                    if (marketCampaigns.isNotEmpty)
                      SimpleAccountCategoryButton(
                        title: intl.onboarding_inviteFriends,
                        icon: const SInviteFriendsIcon(),
                        isSDivider: true,
                        onTap: () {
                          deepLinkService.handle(
                            Uri.parse(marketCampaigns[0].deepLink),
                            source: SourceScreen.bannerOnRewards,
                          );
                        },
                      ),
                    SimpleAccountCategoryButton(
                      title: intl.account_security,
                      icon: const SSecurityIcon(),
                      isSDivider: true,
                      onTap: () {
                        sRouter.push(
                          const AccountSecurityRouter(),
                        );
                      },
                    ),
                    SimpleAccountCategoryButton(
                      title: intl.account_paymentMethods,
                      icon: SActionDepositIcon(
                        color: colors.black,
                      ),
                      isSDivider: true,
                      onTap: () {
                        sRouter.push(
                          const PaymentMethodsRouter(),
                        );
                      },
                    ),
                    SimpleAccountCategoryButton(
                      title: intl.account_transactionHistory,
                      icon: const SIndexHistoryIcon(),
                      isSDivider: true,
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
                    SimpleAccountCategoryButton(
                      title: intl.account_support,
                      icon: const SSupportIcon(),
                      isSDivider: true,
                      onTap: () async {
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
                    SimpleAccountCategoryButton(
                      title: intl.account_helpCenter,
                      icon: const SQuestionIcon(),
                      isSDivider: true,
                      onTap: () {
                        sRouter.push(
                          HelpCenterWebViewRouter(
                            link: faqLink,
                          ),
                        );
                      },
                    ),
                    SimpleAccountCategoryButton(
                      title: intl.account_aboutUs,
                      icon: const SAboutUsIcon(),
                      isSDivider: true,
                      onTap: () {
                        sRouter.push(
                          const AboutUsRouter(),
                        );
                      },
                    ),
                    if (flavor == Flavor.dev || flavor == Flavor.stage)
                      SimpleAccountCategoryButton(
                        title: intl.account_debugInfo,
                        icon: const SInfoIcon(),
                        isSDivider: true,
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
