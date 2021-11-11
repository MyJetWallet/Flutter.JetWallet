import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../shared/components/account_category_button.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../../shared/components/log_out_option.dart';
import '../../../shared/components/security_divider.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../shared/notifiers/logout_notifier/logout_union.dart';
import '../../../shared/providers/service_providers.dart';
import '../../shared/features/about_us/view/about_us.dart';
import '../../shared/features/account_security/view/account_security.dart';
import 'components/account_banner_list/account_banner_list.dart';
import 'components/account_screen_header.dart';

class Account extends HookWidget {
  const Account();

  @override
  Widget build(BuildContext context) {
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final intl = useProvider(intlPod);
    final authInfo = useProvider(authInfoNotipod);

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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AccountScreenHeader(
                  userEmail: authInfo.email,
                ),
                const AccountBannerList(),
                const SpaceH20(),

                SPaddingH24(
                  child: Column(
                    children: <Widget>[
                      AccountCategoryButton(
                        title: 'Profile details',
                        icon: const SProfileDetailsIcon(),
                        isSDivider: true,
                        onTap: () {},
                      ),
                      AccountCategoryButton(
                        title: 'Security',
                        icon: const SSecurityIcon(),
                        isSDivider: true,
                        onTap: () {
                          navigatorPush(context, const AccountSecurity());
                        },
                      ),
                      AccountCategoryButton(
                        title: 'Notifications',
                        icon: const SNotificationsIcon(),
                        isSDivider: true,
                        onTap: () {},
                      ),
                      AccountCategoryButton(
                        title: 'Support',
                        icon: const SSupportIcon(),
                        isSDivider: true,
                        onTap: () {},
                      ),
                      AccountCategoryButton(
                        title: 'FAQ',
                        icon: const SFaqIcon(),
                        isSDivider: true,
                        onTap: () {},
                      ),
                      AccountCategoryButton(
                        title: 'About us',
                        icon: const SAboutUsIcon(),
                        isSDivider: false,
                        onTap: () {
                          navigatorPush(context, const AboutUs());
                        },
                      ),
                    ],
                  ),
                ),
                const SpaceH20(),
                const SecurityDivider(),
                const SpaceH20(),
                LogOutOption(
                  name: intl.logout,
                  onTap: () => logoutN.logout(),
                ),
                const SpaceH20(),
                const SecurityDivider(),
              ],
            ),
          );
        },
        loading: () => const Loader(),
      ),
    );
  }
}
