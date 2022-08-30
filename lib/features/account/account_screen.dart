import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/account/widgets/account_banner_list.dart';
import 'package:jetwallet/features/account/widgets/log_out_option.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/show_plain_snackbar.dart';
import 'package:jetwallet/widgets/loaders/loader.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int debugTapCounter = 0;

  @override
  Widget build(BuildContext context) {
    final flavor = flavorService();

    final logout = getIt.get<LogoutService>();

    final authInfo = getIt.get<AppStore>().authState;
    final userInfo = sUserInfo.userInfo;

    final showPaymentMethods = sSignalRModules.showPaymentsMethods;

    //TODO REFACTOR
    //final cardFailed = useProvider(bottomNavigationNotipod);

    final colors = sKit.colors;

    final kycState = KycService();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    logout.union.when(
      result: (error, st) {
        if (error != null) {
          showPlainSnackbar(context, '$error');
        }
      },
      loading: () {},
    );

    return logout.union.when(
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
                    if (debugTapCounter >= 5) {
                      //navigatorPush(context, const LogsScreen());
                    } else {
                      setState(() {
                        debugTapCounter++;
                      });
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

                        sRouter.push(const SmsAuthenticatorRouter());
                      },
                      onChatBannerTap: () {
                        sAnalytics.bannerClick(
                          bannerName: 'Chat with support',
                        );

                        sRouter.push(
                          CrispRouter(
                            welcomeText: intl.crispSendMessage_hi,
                          ),
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
                          isProgress: kycState.verificationInProgress,
                          currentNavigate: () {},
                          requiredDocuments: kycState.requiredDocuments,
                          requiredVerifications: kycState.requiredVerifications,
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

                            sRouter.push(
                              const ProfileDetailsRouter(),
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
                        if (showPaymentMethods)
                          SimpleAccountCategoryButton(
                            title: intl.account_paymentMethods,
                            icon: SActionDepositIcon(
                              color: colors.black,
                            ),
                            isSDivider: true,
                            notification: false,
                            onTap: () => sRouter.push(
                              const PaymentMethodsRouter(),
                            ),
                          ),
                        SimpleAccountCategoryButton(
                          title: intl.account_recurringBuy,
                          icon: const SRecurringBuysIcon(),
                          isSDivider: true,
                          onTap: () {
                            sRouter.push(
                              HistoryRecurringBuysRouter(
                                from: Source.profile,
                              ),
                            );
                          },
                        ),
                        SimpleAccountCategoryButton(
                          title: intl.account_history,
                          icon: const SIndexHistoryIcon(),
                          isSDivider: true,
                          onTap: () => sRouter.push(
                            TransactionHistoryRouter(),
                          ),
                        ),
                        SimpleAccountCategoryButton(
                          title: intl.account_support,
                          icon: const SSupportIcon(),
                          isSDivider: true,
                          onTap: () => sRouter.push(
                            CrispRouter(
                              welcomeText: intl.crispSendMessage_hi,
                            ),
                          ),
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
                          isSDivider: flavor == Flavor.dev,
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
                            isSDivider: false,
                            onTap: () {
                              sRouter.push(
                                const DebugInfoRouter(),
                              );
                            },
                          ),
                      ],
                    ),
                    const SpaceH20(),
                    const SDivider(),
                    const SpaceH20(),
                    LogOutOption(
                      name: intl.log_out,
                      onTap: () => logout.logout(),
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
    );
  }
}
