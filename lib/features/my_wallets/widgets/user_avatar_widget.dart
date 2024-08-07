import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final kycState = getIt.get<KycService>();

        final notificationsCount = _profileNotificationLength(
          KycModel(
            depositStatus: kycState.depositStatus,
            sellStatus: kycState.tradeStatus,
            withdrawalStatus: kycState.withdrawalStatus,
            requiredDocuments: kycState.requiredDocuments,
            requiredVerifications: kycState.requiredVerifications,
            verificationInProgress: kycState.verificationInProgress,
          ),
          true,
        );

        final showBlueDot = notificationsCount > 0;

        final authInfo = getIt.get<AppStore>().authState;
        final userInfo = sUserInfo;

        final initials = authInfo.email.isNotEmpty
            ? userInfo.firstName.isNotEmpty && userInfo.lastName.isNotEmpty
                ? '${userInfo.firstName.substring(0, 1).toUpperCase()}'
                    '${userInfo.lastName.substring(0, 1).toUpperCase()}'
                : authInfo.email.substring(0, 1).toUpperCase()
            : '';

        return Stack(
          alignment: Alignment.center,
          children: [
            if (showBlueDot)
              SvgPicture.asset(
                userAvatarNotif,
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: SvgPicture.asset(
                  userAvatar,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(right: showBlueDot ? 3 : 0, top: 3),
              child: Text(
                initials,
                style: STStyles.captionBold.copyWith(
                  color: SColorsLight().white,
                ),
              ),
            ),
          ],
        );
      },
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
