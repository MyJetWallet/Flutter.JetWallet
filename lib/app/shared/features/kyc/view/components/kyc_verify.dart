import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../model/kyc_operation_status_model.dart';
import '../../notifier/kyc_steps_notipod.dart';

class KycVerify extends HookWidget {
  const KycVerify({
    Key? key,
    required this.requiredVerifications,
  }) : super(key: key);

  final List<RequiredVerified> requiredVerifications;

  static void pushReplacement({
    required BuildContext context,
    required List<RequiredVerified> requiredVerifications,
  }) {
    navigatorPushReplacement(
      context,
      KycVerify(
        requiredVerifications: requiredVerifications,
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
          for (var i = 0; i < state.requiredVerifications.length; i++) ...[
            if (state.requiredVerifications[i] == RequiredVerified.proofOfPhone)
              VerifyStep(
                title: '${i + 1}. Secure your account',
                colors: colors,
              ),
            if (state.requiredVerifications[i] ==
                RequiredVerified.proofOfIdentity)
              VerifyStep(
                title: '${i + 1}. Verify your identity',
                colors: colors,
              ),
            if (state.requiredVerifications[i] == RequiredVerified.proofOfFunds)
              VerifyStep(
                title: '${i + 1}. Proof source of funds',
                colors: colors,
              ),
            if (state.requiredVerifications[i] ==
                RequiredVerified.proofOfAddress)
              VerifyStep(
                title: '${i + 1}. Address verification',
                colors: colors,
              ),
          ],
          const Spacer(),
          SPrimaryButton2(
            active: true,
            name: 'Continue',
            onTap: () {},
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}

class VerifyStep extends StatelessWidget {
  const VerifyStep({
    Key? key,
    required this.title,
    required this.colors,
  }) : super(key: key);

  final String title;
  final SimpleColors colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 64.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: sSubtitle2Style.copyWith(
                      color: colors
                          .blue, // Todo: change on colors provider or move to simple_kit
                    ),
                  ),
                ),
              ],
            ),
          ),
          // if (isSDivider) const SDivider(),
        ],
      ),
    );
  }
}
