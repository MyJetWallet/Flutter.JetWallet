import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:simple_kit/simple_kit.dart';

class SmsAuthenticator extends StatelessObserverWidget {
  const SmsAuthenticator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = sUserInfo.userInfo;

    return SPageFrame(
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
            switchValue: userInfo.twoFaEnabled,
            onSwitchChanged: (value) {
              if (userInfo.twoFaEnabled) {
                sRouter.push(
                  TwoFaPhoneRouter(
                    trigger: const Security(
                      fromDialog: true,
                    ),
                  ),
                );
              } else {
                if (userInfo.phoneVerified) {
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
                      successText:
                          intl.kycAlertHandler_factorVerificationEnabled,
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
