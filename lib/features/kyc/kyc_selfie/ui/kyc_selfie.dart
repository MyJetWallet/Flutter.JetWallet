import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/store/kyc_selfie_store.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/widgets/empty_selfie_box.dart';
import 'package:jetwallet/features/kyc/kyc_selfie/ui/widgets/selfie_box.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

class KycSelfie extends StatelessWidget {
  const KycSelfie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<KycSelfieStore>(
      create: (context) => KycSelfieStore(),
      builder: (context, child) => const _KycSelfieBody(),
    );
  }
}

class _KycSelfieBody extends StatelessObserverWidget {
  const _KycSelfieBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = KycSelfieStore.of(context);
    final colors = sKit.colors;
    final loader = StackLoaderStore();
    final loaderSuccess = StackLoaderStore();
    final kycN = getIt.get<KycService>();

    sAnalytics.kycSelfieView();

    state.union.maybeWhen(
      error: (error) {
        loader.finishLoading();
      },
      done: () {
        kycN.updateKycStatus();

        sRouter.navigate(
          SuccessKycScreenRoute(
            primaryText: intl.kycAlertHandler_showVerifyingAlertPrimaryText,
            secondaryText: '${intl.kycSelfie_successKycScreenSecondaryText}.',
          ),
        );
      },
      orElse: () {},
    );

    return SPageFrame(
      loaderText: (loaderSuccess.loading)
          ? intl.kycSelfie_done
          : intl.kycSelfie_pleaseWait,
      loading: loader,
      loadSuccess: loaderSuccess,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.kycDocumentType_selfieImage,
        ),
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
                            style: sBodyText1Style,
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
                              style: sBodyText1Style,
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
                              color: colors.grey1,
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
                                    style: sBodyText1Style.copyWith(
                                      color: colors.grey1,
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
                            color: colors.grey1,
                          ),
                          SizedBox(
                            height: 30,
                            child: Text(
                              intl.kycSelfie_removeYourGlasses,
                              maxLines: 3,
                              style: sBodyText1Style.copyWith(
                                color: colors.grey1,
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
            button: SPrimaryButton2(
              onTap: () async {
                if (state.isSelfieNotEmpty) {
                  loader.startLoading();

                  await state.uploadDocuments(
                    kycDocumentTypeInt(KycDocumentType.selfieImage),
                  );
                } else {
                  await state.pickedImage();
                }
              },
              name: (state.isSelfieNotEmpty)
                  ? intl.kycDocumentType_uploadPhoto
                  : intl.kycDocumentType_selfieImage,
              active: true,
              icon: (state.isSelfieNotEmpty)
                  ? const SArrowUpIcon()
                  : const SSelfieIcon(),
            ),
          ),
        ],
      ),
    );
  }
}
