import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/kyc_steps/kyc_steps_notipod.dart';
import '../../../notifier/kyc_steps/kyc_steps_state.dart';
import '../choose_documents/choose_documents.dart';
import 'components/verify_step.dart';

class KycVerifyYourProfile extends HookWidget {
  const KycVerifyYourProfile({
    Key? key,
    required this.requiredVerifications,
    required this.documents,
  }) : super(key: key);

  final List<RequiredVerified> requiredVerifications;
  final List<KycDocumentType> documents;

  static void push({
    required BuildContext context,
    required List<RequiredVerified> requiredVerifications,
    required List<KycDocumentType> documents,
  }) {
    navigatorPush(
      context,
      KycVerifyYourProfile(
        requiredVerifications: requiredVerifications,
        documents: documents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(kycStepsNotipod(requiredVerifications));
    final notifier =
        useProvider(kycStepsNotipod(requiredVerifications).notifier);
    final colors = useProvider(sColorPod);

    return SPageFrameWithPadding(
      header: const SSmallHeader(
        title: 'Verify your profile!',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SVerifyIndicator(
            indicatorToComplete: state.requiredVerifications.length,
            indicator: notifier.getVerifyComplete(),
          ),
          const SpaceH40(),
          for (var index = 0;
              index < state.requiredVerifications.length;
              index++) ...[
            if (state.requiredVerifications[index].requiredVerified ==
                RequiredVerified.proofOfPhone)
              VerifyStep(
                title: '${index + 1}. ${stringRequiredVerified(
                  RequiredVerified.proofOfPhone,
                )}',
                completeIcon: state.requiredVerifications[index].verifiedDone,
                isSDivider: _dividerVerifyStep(
                  state.requiredVerifications.length,
                  index,
                ),
                color: _colorVerifyStep(
                  state.requiredVerifications[index].verifiedDone,
                  index,
                  colors,
                  state.requiredVerifications,
                ),
              ),
            if (state.requiredVerifications[index].requiredVerified ==
                RequiredVerified.proofOfIdentity)
              VerifyStep(
                title: '${index + 1}. ${stringRequiredVerified(
                  RequiredVerified.proofOfIdentity,
                )}',
                completeIcon: state.requiredVerifications[index].verifiedDone,
                isSDivider: _dividerVerifyStep(
                  state.requiredVerifications.length,
                  index,
                ),
                color: _colorVerifyStep(
                  state.requiredVerifications[index].verifiedDone,
                  index,
                  colors,
                  state.requiredVerifications,
                ),
              ),
            if (state.requiredVerifications[index].requiredVerified ==
                RequiredVerified.proofOfFunds)
              VerifyStep(
                title: '${index + 1}. ${stringRequiredVerified(
                  RequiredVerified.proofOfFunds,
                )}',
                completeIcon: state.requiredVerifications[index].verifiedDone,
                isSDivider: _dividerVerifyStep(
                  state.requiredVerifications.length,
                  index,
                ),
                color: _colorVerifyStep(
                  state.requiredVerifications[index].verifiedDone,
                  index,
                  colors,
                  state.requiredVerifications,
                ),
              ),
            if (state.requiredVerifications[index].requiredVerified ==
                RequiredVerified.proofOfAddress)
              VerifyStep(
                title: '${index + 1}. ${stringRequiredVerified(
                  RequiredVerified.proofOfAddress,
                )}',
                completeIcon: state.requiredVerifications[index].verifiedDone,
                isSDivider: _dividerVerifyStep(
                  state.requiredVerifications.length,
                  index,
                ),
                color: _colorVerifyStep(
                  state.requiredVerifications[index].verifiedDone,
                  index,
                  colors,
                  state.requiredVerifications,
                ),
              ),
          ],
          const Spacer(),
          SPrimaryButton2(
            active: true,
            name: 'Continue',
            onTap: () {
              ChooseDocuments.pushReplacement(
                context: context,
                headerTitle: notifier.chooseDocumentsHeaderTitle(),
                documents: documents,
              );
            },
          ),
          const SpaceH24(),
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

    if (index != 0 && !requiredVerifications[index].verifiedDone) {
      if (requiredVerifications[index - 1].verifiedDone) {
        return colors.blue;
      } else {
        return colors.grey1;
      }
    } else {
      return colors.blue;
    }
  }

  bool _dividerVerifyStep(
    int requiredVerificationsLength,
    int index,
  ) {
    return requiredVerificationsLength > 1 &&
        index + 1 != requiredVerificationsLength;
  }
}
