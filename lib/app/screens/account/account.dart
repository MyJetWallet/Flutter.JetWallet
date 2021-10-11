import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../shared/components/buttons/app_button_outlined.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../../shared/components/security_divider.dart';
import '../../../shared/components/security_option.dart';
import '../../../shared/components/spacers.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../shared/notifiers/logout_notifier/logout_union.dart';
import '../../../shared/providers/service_providers.dart';
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
          return Padding(
            padding: EdgeInsets.all(15.r),
            child: ListView(
              children: [
                AccountScreenHeader(
                  userEmail: authInfo.email,
                ),
                const SpaceH20(),
                const AccountBannerList(),
                SecurityOption(
                  name: 'Profile Details',
                  onTap: () {},
                ),
                const SecurityDivider(),
                SecurityOption(
                  name: 'Security',
                  onTap: () {
                    navigatorPush(context, const AccountSecurity());
                  },
                ),
                const SecurityDivider(),
                SecurityOption(
                  name: 'Notifications',
                  onTap: () {},
                ),
                const SecurityDivider(),
                SecurityOption(
                  name: 'Chat with support',
                  onTap: () {},
                ),
                const SecurityDivider(),
                SecurityOption(
                  name: 'FAQ',
                  onTap: () {},
                ),
                const SecurityDivider(),
                SecurityOption(
                  name: 'About Us',
                  onTap: () {},
                ),
                const SecurityDivider(),
                const SpaceH20(),
                AppButtonOutlined(
                  name: intl.logout,
                  onTap: () => logoutN.logout(),
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
