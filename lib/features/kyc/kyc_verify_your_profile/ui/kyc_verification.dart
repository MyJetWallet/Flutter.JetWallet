import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/di/di.dart';
import '../../../../utils/constants.dart';
import '../../kyc_service.dart';

@RoutePage(name: 'KycVerificationRouter')
class KycVerification extends StatelessObserverWidget {
  const KycVerification({
    super.key,
    required this.requiredVerifications,
  });

  final List<RequiredVerified> requiredVerifications;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final isPhoneDone =
        !requiredVerifications.contains(RequiredVerified.proofOfPhone);
    final kycState = getIt.get<KycService>();

    void navigateVerifiedNavigate() {
      if (requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
        sRouter.push(
          SetPhoneNumberRouter(
            successText: intl.kycAlertHandler_factorVerificationEnabled,
            then: () => sRouter.push(
              KycVerifyYourProfileRouter(
                requiredVerifications: requiredVerifications,
              ),
            ),
          ),
        );
      } else {
        
          sRouter.push(
            const KycVerificationSumsubRouter(),
          );
        
      }
    }

    return SPageFrameWithPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH64(),
          Align(
            alignment: Alignment.centerLeft,
            child: SIconButton(
              onTap: () {
                Navigator.pop(context);
              },
              defaultIcon: const SCloseIcon(),
              pressedIcon: const SClosePressedIcon(),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              simpleLogo,
              width: 80,
              height: 80,
            ),
          ),
          const SpaceH24(),
          Text(
            intl.verification_your_profile,
            textAlign: TextAlign.left,
            style: sTextH4Style,
          ),
          const SpaceH8(),
          Text(
            intl.verification_your_profile_descr,
            textAlign: TextAlign.left,
            maxLines: 2,
            style: sBodyText1Style.copyWith(color: colors.grey1),
          ),
          const SpaceH32(),
          _verificationItem(
            intl.kycAlertHandler_secureYourAccount,
            '1',
            isDone: isPhoneDone,
            linkText: intl.provide_information,
            linkAction: () {
              navigateVerifiedNavigate();
            },
          ),
          const SpaceH24(),
          _verificationItem(
            intl.kycAlertHandler_verifyYourIdentity,
            '2',
            haveLink: isPhoneDone,
            linkText: intl.provide_information,
            linkAction: () {
              navigateVerifiedNavigate();
            },
            isDisabled: !isPhoneDone,
          ),
        ],
      ),
    );
  }

  Widget _verificationItem(
    String itemString,
    String step, {
    bool isDone = false,
    bool haveLink = false,
    String? linkText,
    Function()? linkAction,
    bool isDisabled = false,
  }) {
    final colors = sKit.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (isDisabled) const SpaceH3() else const SpaceH4(),
            if (!isDone) ...[
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDisabled ? null : colors.blue,
                    border: isDisabled ? Border.all(color: colors.grey1) : null,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 6,
                        right: 6,
                        bottom: 3,
                      ),
                      child: Text(
                        step,
                        style: sBodyText2Style.copyWith(
                          color: isDisabled ? colors.grey1 : colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              const SBlueDoneIcon(),
            ],
          ],
        ),
        const SpaceW14(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemString,
              style: sSubtitle2Style,
            ),
            if (haveLink) ...[
              const SpaceH12(),
              SLinkButtonText(
                active: true,
                name: linkText ?? '',
                onTap: linkAction ?? () {},
                defaultIcon: const SBlueRightArrowIcon(),
                pressedIcon: SBlueRightArrowIcon(
                  color: colors.blue.withOpacity(0.8),
                ),
                inactiveIcon: const SBlueRightArrowIcon(),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
