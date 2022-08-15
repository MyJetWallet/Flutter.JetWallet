import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../core/stage/logs_screen/view/logs_screen.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../shared/notifiers/logout_notifier/logout_union.dart';
import '../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../shared/providers/flavor_pod.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/features/about_us/about_us.dart';
import '../../shared/features/account_security/view/account_security.dart';
import '../../shared/features/debug_info/debug_info.dart';
import '../../shared/features/kyc/notifier/kyc/kyc_notipod.dart';
import '../../shared/features/payment_methods/view/payment_methods.dart';
import '../../shared/features/profile_details/view/profile_details.dart';
import '../../shared/features/sms_autheticator/sms_authenticator.dart';
import '../../shared/features/transaction_history/components/history_recurring_buys.dart';
import '../../shared/features/transaction_history/view/transaction_hisotry.dart';
import '../../shared/helpers/check_kyc_status.dart';
import '../../shared/providers/show_payment_methods_pod/show_payment_methods_pod.dart';
import '../navigation/provider/bottom_navigation_notipod.dart';
import 'components/account_banner_list.dart';
import 'components/crisp.dart';
import 'components/help_center_web_view.dart';
import 'components/log_out_option.dart';

class Account extends HookWidget {
  const Account();

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final flavor = useProvider(flavorPod);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final userInfo = useProvider(userInfoNotipod);
    final showPaymentMethods = useProvider(showPaymentsMethodsPod);
    final cardFailed = useProvider(bottomNavigationNotipod);

    final colors = useProvider(sColorPod);

    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );

    final debugTapCounter = useState(0);

    return ProviderListener<LogoutUnion>(
      provider: logoutNotipod,
      onChange: (context, union) {
        union.when(
          result: (error, st) {
            if (error != null) {
              showPlainSnackbar(context, '$error');
            }
          },
          loading: () {},
        );
      },
      child: logout.when(
        result: (_, __) {
          return Material(
            color: colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SPaddingH24(
                  child: SimpleAccountCategoryHeader(
                    onIconTap: () {
                      if (debugTapCounter.value >= 5) {
                        navigatorPush(context, const LogsScreen());
                      } else {
                        debugTapCounter.value++;
                      }
                    },
                    userEmail: authInfo.email,
                    userFirstName: userInfo.firstName,
                    userLastName: userInfo.lastName,
                    showUserName: userInfo.firstName.isNotEmpty &&
                        userInfo.lastName.isNotEmpty,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      AccountBannerList(
                        kycPassed: checkKycPassed(
                          kycState.depositStatus,
                          kycState.sellStatus,
                          kycState.withdrawalStatus,
                        ),
                        verificationInProgress: kycState.inVerificationProgress,
                        twoFaEnabled: userInfo.twoFaEnabled,
                        phoneVerified: userInfo.phoneVerified,
                        onTwoFaBannerTap: () {
                          sAnalytics.bannerClick(
                              bannerName: '2-Factor Authentication',
                          );
                          SmsAuthenticator.push(context);
                        },
                        onChatBannerTap: () {
                          sAnalytics.bannerClick(
                            bannerName: 'Chat with support',
                          );
                          Crisp.push(
                            context,
                            intl.crispSendMessage_hi,
                          );
                        },
                        onKycBannerTap: () {
                          sAnalytics.bannerClick(
                            bannerName: 'KYC banner',
                          );
                          defineKycVerificationsScope(
                            kycState.requiredVerifications.length,
                            Source.accountBanner,
                          );

                          kycAlertHandler.handle(
                            status: kycState.depositStatus,
                            kycVerified: kycState,
                            isProgress: kycState.verificationInProgress,
                            currentNavigate: () {},
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
                              sAnalytics.account();
                              navigatorPush(context, const ProfileDetails());
                            },
                          ),
                          SimpleAccountCategoryButton(
                            title: intl.account_security,
                            icon: const SSecurityIcon(),
                            isSDivider: true,
                            onTap: () {
                              navigatorPush(context, const AccountSecurity());
                            },
                          ),
                          if (showPaymentMethods)
                            SimpleAccountCategoryButton(
                              title: intl.account_paymentMethods,
                              icon: SActionDepositIcon(
                                color: colors.black,
                              ),
                              isSDivider: true,
                              notification: cardFailed.cardNotification,
                              onTap: () => PaymentMethods.push(context),
                            ),
                          SimpleAccountCategoryButton(
                            title: intl.account_recurringBuy,
                            icon: const SRecurringBuysIcon(),
                            isSDivider: true,
                            onTap: () {
                              navigatorPush(
                                context,
                                const HistoryRecurringBuys(from:Source.profile,
                                ),
                              );
                            },
                          ),
                          SimpleAccountCategoryButton(
                            title: intl.account_history,
                            icon: const SIndexHistoryIcon(),
                            isSDivider: true,
                            onTap: () => TransactionHistory.push(
                              context: context,
                            ),
                          ),
                          SimpleAccountCategoryButton(
                            title: intl.account_support,
                            icon: const SSupportIcon(),
                            isSDivider: true,
                            onTap: () => Crisp.push(
                              context,
                              intl.crispSendMessage_hi,
                            ),
                          ),
                          SimpleAccountCategoryButton(
                            title: intl.account_helpCenter,
                            icon: const SQuestionIcon(),
                            isSDivider: true,
                            onTap: () {
                              HelpCenterWebView.push(
                                context: context,
                                link: faqLink,
                              );
                            },
                          ),
                          SimpleAccountCategoryButton(
                            title: intl.account_aboutUs,
                            icon: const SAboutUsIcon(),
                            isSDivider: flavor == Flavor.dev,
                            onTap: () {
                              navigatorPush(context, const AboutUs());
                            },
                          ),
                          if (flavor == Flavor.dev || flavor == Flavor.stage)
                            SimpleAccountCategoryButton(
                              title: intl.account_debugInfo,
                              icon: const SInfoIcon(),
                              isSDivider: false,
                              onTap: () {
                                navigatorPush(context, const DebugInfo());
                              },
                            ),
                        ],
                      ),
                      const SpaceH20(),
                      const SDivider(),
                      const SpaceH20(),
                      LogOutOption(
                        name: intl.log_out,
                        onTap: () => logoutN.logout(),
                      ),
                      const SpaceH20(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Loader(),
      ),
    );
  }
}
