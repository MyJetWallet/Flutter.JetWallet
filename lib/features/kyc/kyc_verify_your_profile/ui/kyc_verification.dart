import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/get_kuc_aid_plan.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/start_kyc_aid_flow.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

import '../../../../utils/constants.dart';

@RoutePage(name: 'KycVerificationRouter')
class KycVerification extends StatefulObserverWidget {
  const KycVerification({
    super.key,
    required this.requiredVerifications,
  });

  final List<RequiredVerified> requiredVerifications;

  @override
  State<KycVerification> createState() => _KycVerificationState();
}

class _KycVerificationState extends State<KycVerification> {
  bool isPhoneDone = false;

  List<RequiredVerified> requiredVerifications = <RequiredVerified>[];

  KycPlanResponceModel? kycPlan;

  @override
  void initState() {
    super.initState();
    isPhoneDone = !widget.requiredVerifications.contains(RequiredVerified.proofOfPhone);
    requiredVerifications = widget.requiredVerifications;
    sAnalytics.kycFlowVerificationScreenView();
    getKYCPlan();
  }

  Future<void> getKYCPlan() async {
    kycPlan = await getKYCAidPlan();
  }

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    void navigateVerifiedNavigate() {
      if (requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
        sRouter
            .push(
          SetPhoneNumberRouter(
            successText: intl.kycAlertHandler_factorVerificationEnabled,
            then: () async {
              setState(() {
                isPhoneDone = true;
              });

              sRouter.popUntilRouteWithName(KycVerificationRouter.name);

              requiredVerifications.remove(RequiredVerified.proofOfPhone);

              if (kycPlan?.provider == KycProvider.sumsub) {
                unawaited(
                  getIt<SumsubService>().launch(
                    isBanking: false,
                  ),
                );
              } else if (kycPlan?.provider == KycProvider.kycAid) {
                unawaited(
                  startKycAidFlow(kycPlan!).then((_) {
                    getKYCPlan();
                  }),
                );
              }
            },
          ),
        )
            .then((_) {
          getKYCPlan();
        });
      } else {
        if (kycPlan?.provider == KycProvider.sumsub) {
          unawaited(
            getIt<SumsubService>().launch(
              isBanking: false,
            ),
          );
        } else if (kycPlan?.provider == KycProvider.kycAid) {
          unawaited(
            startKycAidFlow(kycPlan!).then((_) {
              getKYCPlan();
            }),
          );
        }
      }
    }

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        leftIcon: Assets.svg.medium.close.simpleSvg(),
        onLeftIconTap: () {
          Navigator.pop(context);
        },
        rightIcon: Text(
          intl.logout,
          textAlign: TextAlign.right,
          style: STStyles.button.copyWith(
            color: colors.blue,
          ),
        ),
        onRightIconTap: () {
          getIt.get<LogoutService>().logout(
                'Verification your profile',
                callbackAfterSend: () {},
              );
        },
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    logoGradientRounded,
                    width: 80,
                    height: 80,
                  ),
                  const SpaceH24(),
                  Text(
                    intl.verification_your_profile,
                    textAlign: TextAlign.left,
                    style: STStyles.header5,
                    maxLines: 2,
                  ),
                  const SpaceH8(),
                  Text(
                    intl.verification_your_profile_descr,
                    textAlign: TextAlign.left,
                    maxLines: 4,
                    style: STStyles.body1Medium.copyWith(color: colors.gray10),
                  ),
                  const SpaceH24(),
                  VerificationItem(
                    itemString: intl.kycAlertHandler_secureYourAccount,
                    isDone: isPhoneDone,
                  ),
                  VerificationItem(
                    itemString: intl.kycAlertHandler_verifyYourIdentity,
                    isDisabled: !isPhoneDone,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: SButton.blue(
                      text: isPhoneDone ? 'Verify identity' : 'Secure account',
                      callback: () {
                        navigateVerifiedNavigate();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationItem extends StatelessWidget {
  const VerificationItem({
    required this.itemString,
    this.isDone = false,
    this.isDisabled = false,
  });

  final String itemString;
  final bool isDone;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (isDisabled)
            Assets.svg.small.minusCircle.simpleSvg(
              color: colors.gray10,
            )
          else if (!isDone)
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(left: 2),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.black,
              ),
            )
          else
            Assets.svg.small.minusCircle.simpleSvg(
              color: colors.blue,
            ),
          const SpaceW16(),
          Text(
            itemString,
            style: STStyles.subtitle1.copyWith(
              color: isDisabled
                  ? colors.gray10
                  : isDone
                      ? colors.blue
                      : colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
