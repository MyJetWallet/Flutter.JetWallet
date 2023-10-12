import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/models/modify_required_model.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/store/kyc_steps_store.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/ui/widgets/verify_step.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'KycVerifyYourProfileRouter')
class KycVerifyYourProfile extends StatelessObserverWidget {
  const KycVerifyYourProfile({
    super.key,
    required this.requiredVerifications,
    this.onFinish,
  });

  final List<RequiredVerified> requiredVerifications;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    final store = KycStepsStore(requiredVerifications);
    final colors = sKit.colors;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.kycVerifyYourProfile_verifyYourProfile}!',
        ),
      ),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: SPaddingH24(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SVerifyIndicator(
                        indicatorToComplete: store.requiredVerifications.length,
                        indicator: store.getVerifyComplete(),
                      ),
                      const SpaceH40(),
                      for (var index = 0; index < store.requiredVerifications.length; index++) ...[
                        if (store.requiredVerifications[index].requiredVerified == RequiredVerified.proofOfPhone)
                          VerifyStep(
                            title: '${index + 1}. ${stringRequiredVerified(
                              RequiredVerified.proofOfPhone,
                            )}',
                            completeIcon: store.requiredVerifications[index].verifiedDone,
                            isSDivider: _dividerVerifyStep(
                              store.requiredVerifications.length,
                              index,
                            ),
                            color: _colorVerifyStep(
                              store.requiredVerifications[index].verifiedDone,
                              index,
                              colors,
                              store.requiredVerifications,
                            ),
                          ),
                        if (store.requiredVerifications[index].requiredVerified == RequiredVerified.proofOfIdentity)
                          VerifyStep(
                            title: '${index + 1}. ${stringRequiredVerified(
                              RequiredVerified.proofOfIdentity,
                            )}',
                            completeIcon: store.requiredVerifications[index].verifiedDone,
                            isSDivider: _dividerVerifyStep(
                              store.requiredVerifications.length,
                              index,
                            ),
                            color: _colorVerifyStep(
                              store.requiredVerifications[index].verifiedDone,
                              index,
                              colors,
                              store.requiredVerifications,
                            ),
                          ),
                        if (store.requiredVerifications[index].requiredVerified == RequiredVerified.proofOfFunds)
                          VerifyStep(
                            title: '${index + 1}. ${stringRequiredVerified(
                              RequiredVerified.proofOfFunds,
                            )}',
                            completeIcon: store.requiredVerifications[index].verifiedDone,
                            isSDivider: _dividerVerifyStep(
                              store.requiredVerifications.length,
                              index,
                            ),
                            color: _colorVerifyStep(
                              store.requiredVerifications[index].verifiedDone,
                              index,
                              colors,
                              store.requiredVerifications,
                            ),
                          ),
                        if (store.requiredVerifications[index].requiredVerified == RequiredVerified.proofOfAddress)
                          VerifyStep(
                            title: '${index + 1}. ${stringRequiredVerified(
                              RequiredVerified.proofOfAddress,
                            )}',
                            completeIcon: store.requiredVerifications[index].verifiedDone,
                            isSDivider: _dividerVerifyStep(
                              store.requiredVerifications.length,
                              index,
                            ),
                            color: _colorVerifyStep(
                              store.requiredVerifications[index].verifiedDone,
                              index,
                              colors,
                              store.requiredVerifications,
                            ),
                          ),
                      ],
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SFloatingButtonFrame(
            button: SPrimaryButton2(
              active: true,
              name: intl.kycVerifyYourProfile_continue,
              onTap: () async {
                await getIt<SumsubService>().launch(
                  onFinish: onFinish,
                  isBanking: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _colorVerifyStep(
    bool verifiedDone,
    int index,
    SimpleColors colors,
    List<ModifyRequiredVerified> requiredVerifications,
  ) {
    if (verifiedDone) {
      return colors.black;
    }

    return index != 0 && !requiredVerifications[index].verifiedDone
        ? requiredVerifications[index - 1].verifiedDone
            ? colors.blue
            : colors.grey1
        : colors.blue;
  }

  bool _dividerVerifyStep(
    int requiredVerificationsLength,
    int index,
  ) {
    return requiredVerificationsLength > 1 && index + 1 != requiredVerificationsLength;
  }
}
