import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/kyc_operation_status_model.dart';

import 'kyc_steps_notifier.dart';
import 'kyc_steps_state.dart';

final kycStepsNotipod = StateNotifierProvider
    .family<KycStepsNotifier, KycStepsState, List<RequiredVerified>>(
      (ref, requiredVerifications) {

    final modifyRequiredVerified = <ModifyRequiredVerified>[];
    for (var i = 0; i < requiredVerifications.length; i++) {
      if (requiredVerifications[i] == RequiredVerified.proofOfPhone) {
        modifyRequiredVerified.add(
          ModifyRequiredVerified(
            requiredVerified: requiredVerifications[i],
            verifiedDone: true,
          ),
        );
      } else {
        modifyRequiredVerified.add(
          ModifyRequiredVerified(
            requiredVerified: requiredVerifications[i],
          ),
        );
      }
    }

    return KycStepsNotifier(
      read: ref.read,
      requiredVerifications: modifyRequiredVerified,
    );
  },
);
