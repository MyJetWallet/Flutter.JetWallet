import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/kyc/kyc_notipod.dart';
import '../../../notifier/kyc_selfie/kyc_selfie_notipod.dart';
import '../../../notifier/kyc_selfie/kyc_selfie_state.dart';
import 'components/empty_selfie_box.dart';
import 'components/selfie_box.dart';
import 'components/success_kys_screen.dart';

class KycSelfie extends HookWidget {
  const KycSelfie({Key? key}) : super(key: key);

  static void pushReplacement({
    required BuildContext context,
  }) {
    navigatorPushReplacement(
      context,
      const KycSelfie(),
    );
  }

  static void push({
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      const KycSelfie(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(kycSelfieNotipod);
    final notifier = useProvider(kycSelfieNotipod.notifier);
    final colors = useProvider(sColorPod);
    final loader = useValueNotifier(StackLoaderNotifier());
    final kycN = useProvider(kycNotipod.notifier);

    return ProviderListener<KycSelfieState>(
      provider: kycSelfieNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            loader.value.finishLoading();
          },
          done: () {
            kycN.updateKycStatus();
            SuccessKycScreen.pushReplacement(
              context: context,
              primaryText: 'We’re verifying now',
              secondaryText:
                  'You’ll be notified after we’ve completed the process. '
                  'Usually within a few minutes.',
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrameWithPadding(
        header: const SSmallHeader(
          title: 'Take a selfi',
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  if (state.selfie == null)
                    EmptySelfieBox(
                      colors: colors,
                    ),
                  if (state.selfie != null) const SelfieBox(),
                  const Spacer(),
                  Row(
                    children: const [
                      Text('We’ll compare it with your document.'),
                    ],
                  ),
                  Row(
                    children: const [
                      Baseline(
                        baseline: 48,
                        baselineType: TextBaseline.alphabetic,
                        child: Text('The selfi should clearly show:'),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Positioned(
                        top: 24,
                        child: Container(
                          height: 3,
                          width: 6,
                          margin: const EdgeInsets.only(right: 10.0),
                          color: colors.grey1,
                        ),
                      ),
                      Row(
                        children: [
                          const SpaceW16(),
                          Baseline(
                            baseline: 30,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              'Face forward and make sure your eyes\n'
                              'are clearly visible',
                              style: sBodyText1Style.copyWith(
                                color: colors.grey1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 3,
                        width: 6,
                        margin: const EdgeInsets.only(right: 10.0),
                        color: colors.grey1,
                      ),
                      SizedBox(
                        height: 30,
                        child: Text(
                          'Remove your glasses, if necessary',
                          maxLines: 3,
                          style: sBodyText1Style.copyWith(
                            color: colors.grey1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24.0,
                      top: 40.0,
                    ),
                    child: SPrimaryButton2(
                      onTap: () async {
                        if (state.isSelfieNotEmpty) {
                          loader.value.startLoading();
                          await notifier.uploadDocuments(
                            kycDocumentTypeInt(KycDocumentType.selfieImage),
                          );
                        } else {
                          await notifier.pickedImage();
                        }
                      },
                      name: (state.isSelfieNotEmpty)
                          ? 'Upload photo'
                          : 'Take a selfie',
                      active: true,
                      icon: (state.isSelfieNotEmpty)
                          ? const SArrowUpIcon()
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: 17.0,
                                bottom: 17.0,
                              ),
                              child: SvgPicture.asset(
                                personaAsset,
                                color: colors.grey5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
