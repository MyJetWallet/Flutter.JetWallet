import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SmsAuthenticatorRouter')
class SmsAuthenticator extends StatelessObserverWidget {
  const SmsAuthenticator({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.smsAuth_headerTitle,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          SimpleAccountCategoryButton(
            title: intl.smsAuth_headerTitle,
            icon: const SLockIcon(),
            isSDivider: false,
            switchValue: sUserInfo.twoFaEnabled,
            onSwitchChanged: (value) {
              if (sUserInfo.twoFaEnabled) {
                sRouter.push(
                  TwoFaPhoneRouter(
                    trigger: const Security(
                      fromDialog: true,
                    ),
                  ),
                );
              } else {
                if (sUserInfo.phoneVerified) {
                  sRouter.push(
                    TwoFaPhoneRouter(
                      trigger: const TwoFaPhoneTriggerUnion.security(
                        fromDialog: false,
                      ),
                    ),
                  );
                } else {
                  sRouter.push(
                    SetPhoneNumberRouter(
                      successText: intl.kycAlertHandler_factorVerificationEnabled,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
