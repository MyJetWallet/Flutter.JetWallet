import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_kit/simple_kit.dart';

class RewardsHeader extends StatelessWidget {
  const RewardsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
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

    return SafeArea(
      child: Row(
        children: [
          const SpaceW24(),
          Text(
            intl.rewards_flow_tab_title,
            style: sTextH4Style,
          ),
          const Spacer(),
          SizedBox(
            height: 49,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SIconButton(
                      defaultIcon: SProfileDetailsIcon(
                        color: sKit.colors.black,
                      ),
                      pressedIcon: SProfileDetailsIcon(
                        color: sKit.colors.black.withOpacity(0.7),
                      ),
                      onTap: () {
                        sRouter.push(const AccountRouter());
                      },
                    ),
                    const SpaceW24(),
                  ],
                ),
                if (notificationsCount != 0)
                  Positioned(
                    right: 17,
                    top: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: ShapeDecoration(
                        color: colors.purple,
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: colors.white,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          notificationsCount.toString(),
                          textAlign: TextAlign.center,
                          style: sTextButtonStyle.copyWith(
                            color: colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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
