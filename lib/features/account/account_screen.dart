import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/account/widgets/account_banner_list.dart';
import 'package:jetwallet/features/account/widgets/log_out_option.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/show_plain_snackbar.dart';
import 'package:jetwallet/widgets/loaders/loader.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountScreen extends StatefulObserverWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  int debugTapCounter = 0;

  @override
  Widget build(BuildContext context) {
    final flavor = flavorService();

    final logout = getIt.get<LogoutService>();

    final authInfo = getIt.get<AppStore>().authState;
    final userInfo = sUserInfo.userInfo;
    final userInfoN = getIt.get<UserInfoService>();
    userInfoN.initBiometricStatus();

    //TODO REFACTOR
    //final cardFailed = useProvider(bottomNavigationNotipod);

    final colors = sKit.colors;

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

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
        children: <Widget>[
          SPaddingH24(
            child: SimpleAccountCategoryHeader(
              onIconTap: () {
                if (debugTapCounter >= 4) {
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
              showUserName:
                  userInfo.firstName.isNotEmpty && userInfo.lastName.isNotEmpty,
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
                    kycState.sellStatus,
                    kycState.withdrawalStatus,
                  ),
                  kycBlocked: checkKycBlocked(
                    kycState.depositStatus,
                    kycState.sellStatus,
                    kycState.withdrawalStatus,
                  ),
                  verificationInProgress: kycState.inVerificationProgress,
                  twoFaEnabled: true,
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
                    final isDepositAllow = kycState.depositStatus !=
                        kycOperationStatus(KycStatus.allowed);
                    final isWithdrawalAllow = kycState.withdrawalStatus !=
                        kycOperationStatus(KycStatus.allowed);

                    kycAlertHandler.handle(
                      status: isDepositAllow
                          ? kycState.depositStatus
                          : isWithdrawalAllow
                              ? kycState.withdrawalStatus
                              : kycState.sellStatus,
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
                    SimpleAccountCategoryButton(
                      title: intl.account_paymentMethods,
                      icon: SActionDepositIcon(
                        color: colors.black,
                      ),
                      isSDivider: true,
                      notification: false,
                      onTap: () {
                        sRouter.push(
                          const PaymentMethodsRouter(),
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
                  onTap: () => logout.logout('account logout'),
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
