import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/bottom_navigation_bar/components/notification_box.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/icons/24x24/public/profile_details/simple_profile_details_icon.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../utils/helpers/check_kyc_status.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_verified_model.dart';

class IBanHeader extends StatelessObserverWidget {
  const IBanHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final kycState = getIt.get<KycService>();

    return Column(
      children: [
        const SpaceH54(),
        Row(
          children: [
            const SpaceW24(),
            Text(
              intl.bottom_bar_account,
              style: sTextH4Style,
            ),
            const Spacer(),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SProfileDetailsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SProfileDetailsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      sRouter.push(const AccountRouter());
                    },
                  ),
                  NotificationBox(
                    notifications: _profileNotificationLength(
                      KycModel(
                        depositStatus: kycState.depositStatus,
                        sellStatus: kycState.sellStatus,
                        withdrawalStatus: kycState.withdrawalStatus,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                        verificationInProgress: kycState.verificationInProgress,
                      ),
                      true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceW34(),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SProfileDetailsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SProfileDetailsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      sRouter.push(const AccountRouter());
                    },
                  ),
                  NotificationBox(
                    notifications: _profileNotificationLength(
                      KycModel(
                        depositStatus: kycState.depositStatus,
                        sellStatus: kycState.sellStatus,
                        withdrawalStatus: kycState.withdrawalStatus,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                        verificationInProgress: kycState.verificationInProgress,
                      ),
                      true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceW8(),
          ],
        ),
      ],
    );
  }

  int _profileNotificationLength(KycModel kycState, bool twoFaEnable) {
    var notificationLength = 0;

    final passed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );

    if (!passed) {
      notificationLength += 1;
    }

    if (!twoFaEnable) {
      notificationLength += 1;
    }

    return notificationLength;
  }
}
