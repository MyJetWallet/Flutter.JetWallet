import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/models/kyc_selfie_union.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/store/kyc_selfie_store.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/widgets/empty_selfie_box.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/widgets/selfie_box.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/widgets/simple_floating_button_frame.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

// TODO (Yaroslav): this screen isn't using in the app
@RoutePage(name: 'KycSelfieRouter')
class KycSelfie extends StatelessWidget {
  const KycSelfie({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<KycSelfieStore>(
      create: (context) => KycSelfieStore(),
      builder: (context, child) => const _KycSelfieBody(),
    );
  }
}

class _KycSelfieBody extends StatelessObserverWidget {
  const _KycSelfieBody();

  @override
  Widget build(BuildContext context) {
    final state = KycSelfieStore.of(context);
    final colors = SColorsLight();

    final kycN = getIt.get<KycService>();

    return ReactionBuilder(
      builder: (context) {
        return reaction<KycSelfieUnion>(
          (_) => state.union,
          (result) {
            result.maybeWhen(
              error: (error) {
                state.loader.finishLoading();
              },
              done: () {
                kycN.updateKycStatus();

                sRouter.push(
                  SuccessKycScreenRoute(
                    primaryText: intl.kycAlertHandler_showVerifyingAlertPrimaryText,
                    secondaryText: '${intl.kycSelfie_successKycScreenSecondaryText}.',
                  ),
                );
              },
              orElse: () {},
            );
          },
          fireImmediately: true,
        );
      },
      child: SPageFrame(
        loaderText: (state.loaderSuccess.loading) ? intl.kycSelfie_done : intl.kycSelfie_pleaseWait,
        loading: state.loader,
        loadSuccess: state.loaderSuccess,
        header: GlobalBasicAppBar(
          title: intl.kycDocumentType_selfieImage,
          hasRightIcon: false,
        ),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const Spacer(),
                      if (state.selfie == null)
                        SPaddingH24(
                          child: EmptySelfieBox(
                            colors: colors,
                          ),
                        ),
                      if (state.selfie != null) const SelfieBox(),
                      const Spacer(),
                      SPaddingH24(
                        child: Row(
                          children: [
                            Text(
                              '${intl.kycSelfie_compareWithYourDocument}.',
                              style: STStyles.body1Medium,
                            ),
                          ],
                        ),
                      ),
                      SPaddingH24(
                        child: Row(
                          children: [
                            Baseline(
                              baseline: 48,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                '${intl.kycSelfie_selfieShouldClearly}:',
                                style: STStyles.body1Medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SPaddingH24(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 24,
                              child: Container(
                                height: 3,
                                width: 6,
                                margin: const EdgeInsets.only(right: 10.0),
                                color: colors.gray10,
                              ),
                            ),
                            Row(
                              children: [
                                const SpaceW16(),
                                Flexible(
                                  child: Baseline(
                                    baseline: 30,
                                    baselineType: TextBaseline.alphabetic,
                                    child: Text(
                                      '${intl.kycSelfie_faceForwardAndMakeSure}'
                                      '${intl.kycSelfie_clearlyVisible}',
                                      maxLines: 2,
                                      style: STStyles.body1Medium.copyWith(
                                        color: colors.gray10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SPaddingH24(
                        child: Row(
                          children: [
                            Container(
                              height: 3,
                              width: 6,
                              margin: const EdgeInsets.only(right: 10.0),
                              color: colors.gray10,
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(
                                intl.kycSelfie_removeYourGlasses,
                                maxLines: 3,
                                style: STStyles.body1Medium.copyWith(
                                  color: colors.gray10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpaceH120(),
                    ],
                  ),
                ),
              ],
            ),
            SFloatingButtonFrame(
              button: SButton.blue(
                callback: () async {
                  if (state.isSelfieNotEmpty) {
                    state.loader.startLoading();

                    await state.uploadDocuments(
                      kycDocumentTypeInt(KycDocumentType.selfieImage),
                    );
                  } else {
                    await state.pickedImage();
                  }
                },
                text: (state.isSelfieNotEmpty) ? intl.kycDocumentType_uploadPhoto : intl.kycDocumentType_selfieImage,
                icon: (state.isSelfieNotEmpty) ? const SArrowUpIcon() : const SSelfieIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
