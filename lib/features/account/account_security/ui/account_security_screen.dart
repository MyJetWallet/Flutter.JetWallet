import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/account/account_security/ui/widgets/security_protection.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountSecurity extends StatelessObserverWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = getIt.get<UserInfoService>();

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.account_security,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SpaceH20(),
          const SPaddingH24(
            child: SecurityProtection(),
          ),
          const SpaceH40(),

          /// Temporary comment for release
          // SimpleAccountCategoryButton(
          //   title: intl.accountSecurity_accountCategoryButtonTitle1,
          //   icon: const SLockIcon(),
          //   isSDivider: true,
          //   onSwitchChanged: (value) {
          //     if (userInfo.pinEnabled) {
          //       PinScreen.push(context, const Disable());
          //     } else {
          //       PinScreen.push(context, const Enable());
          //     }
          //   },
          //   switchValue: userInfo.pinEnabled,
          // ),
          if (userInfo.userInfo.pinEnabled)
            SimpleAccountCategoryButton(
              title: intl.accountSecurity_changePin,
              icon: const SChangePinIcon(),
              isSDivider: true,
              onTap: () => sRouter.push(
                PinScreenRoute(
                  union: const PinFlowUnion.change(),
                ),
              ),
            ),
          SimpleAccountCategoryButton(
            title: intl.accountSecurity_accountCategoryButtonTitle3,
            icon: const STwoFactorAuthIcon(),
            isSDivider: false,
            onTap: () => sRouter.push(const SmsAuthenticatorRouter()),
          ),
        ],
      ),
    );
  }
}
