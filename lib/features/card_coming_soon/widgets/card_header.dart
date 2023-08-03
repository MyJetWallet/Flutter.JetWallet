import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/bottom_navigation_bar/components/notification_box.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../utils/helpers/check_kyc_status.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_verified_model.dart';

class CardHeader extends StatelessObserverWidget {
  const CardHeader({
    Key? key,
  }) : super(key: key);

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
              intl.card_header,
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
            const SpaceW8(),
          ],
        ),
        const SpaceH12(),
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
