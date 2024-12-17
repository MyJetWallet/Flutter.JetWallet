import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/models/upload_kyc_documents_union.dart';
import 'package:jetwallet/features/kyc/upload_documents/store/upload_kyc_documents_store.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/create_kyc_banners_list.dart';
import 'package:jetwallet/features/kyc/upload_documents/ui/widgets/document_page_view.dart';
import 'package:jetwallet/widgets/simple_floating_button_frame.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

// TODO (Yaroslav): this screen isn't using in the app
@RoutePage(name: 'UploadVerificationPhotoRouter')
class UploadVerificationPhoto extends StatelessWidget {
  const UploadVerificationPhoto({
    super.key,
    this.isSelfie = false,
    required this.cardId,
    required this.onSuccess,
  });

  final bool isSelfie;
  final String cardId;
  final Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    return Provider<UploadKycDocumentsStore>(
      create: (context) => UploadKycDocumentsStore(),
      builder: (context, child) => _UploadVerificationPhotoBody(
        isSelfie: isSelfie,
        cardId: cardId,
        onSuccess: onSuccess,
      ),
    );
  }
}

class _UploadVerificationPhotoBody extends StatelessObserverWidget {
  const _UploadVerificationPhotoBody({
    required this.isSelfie,
    required this.cardId,
    required this.onSuccess,
  });

  final bool isSelfie;
  final String cardId;
  final Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    final store = UploadKycDocumentsStore.of(context);
    final colors = SColorsLight();

    final banners = createKycBannersList(
      documentFirstSide: store.documentFirstSide,
      documentSecondSide: store.documentSecondSide,
      documentSelfie: store.documentSelfie,
      documentCard: store.documentCard,
      selfie: isSelfie,
      card: !isSelfie,
      showSides: false,
      colors: colors,
      notifier: store,
    );

    return ReactionBuilder(
      builder: (context) {
        return reaction<UploadKycDocumentsUnion>(
          (_) => store.union,
          (result) {
            result.maybeWhen(
              error: (error) {
                store.loader.finishLoadingImmediately();
              },
              done: () {
                store.loaderSuccess.startLoading();
                Timer(const Duration(seconds: 2), () {
                  sRouter.navigate(const KycSelfieRouter());
                });
              },
              orElse: () {},
            );
          },
          fireImmediately: true,
        );
      },
      child: SPageFrame(
        loaderText: (store.loaderSuccess.loading) ? intl.uploadKycDocuments_done : intl.uploadKycDocuments_pleaseWait,
        loading: store.loader,
        loadSuccess: store.loaderSuccess,
        header: SimpleLargeAppbar(
          title: intl.cardVerification_title,
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
                      SPaddingH24(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 280,
                              child: Text(
                                intl.cardVerification_providePhoto,
                                maxLines: 2,
                                style: STStyles.body1Medium.copyWith(
                                  color: colors.gray10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SpaceH32(),
                      DocumentPageView(
                        pageController: store.pageViewController,
                        onPageChanged: (int index) {
                          store.changeDocumentSide(index);
                        },
                        itemCount: 1,
                        banners: banners,
                      ),
                      const SpaceH32(),
                      SPaddingH24(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 280,
                              child: Text(
                                intl.cardVerification_coverSymbols,
                                maxLines: 5,
                                style: STStyles.body1Medium.copyWith(
                                  color: colors.gray10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SpaceH10(),
                      SPaddingH24(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Text(
                                    intl.cardVerification_photoShow,
                                    textAlign: TextAlign.center,
                                    style: STStyles.body1Medium.copyWith(
                                      color: colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isSelfie)
                              Row(
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
                                      intl.cardVerification_face,
                                      textAlign: TextAlign.center,
                                      style: STStyles.body1Medium.copyWith(
                                        color: colors.gray10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Row(
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
                                    intl.cardVerification_nameAndDate,
                                    textAlign: TextAlign.center,
                                    style: STStyles.body1Medium.copyWith(
                                      color: colors.gray10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
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
                                    intl.cardVerification_digits,
                                    textAlign: TextAlign.center,
                                    style: STStyles.body1Medium.copyWith(
                                      color: colors.gray10,
                                    ),
                                  ),
                                ),
                              ],
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
                  final status = await Permission.camera.request();

                  if (status == PermissionStatus.granted) {
                    await store.documentPageViewLogic(
                      isSelfie ? KycDocumentType.selfieWithCard : KycDocumentType.creditCard,
                      cardId,
                      onSuccess,
                    );
                  } else {
                    await sRouter.push(
                      AllowCameraRoute(
                        permissionDescription: '''${intl.chooseDocuments_permissionDescriptionText1} '''
                            '${intl.chooseDocument_camera}',
                        then: () async {
                          Navigator.pop(context);
                          await store.documentPageViewLogic(
                            isSelfie ? KycDocumentType.selfieWithCard : KycDocumentType.creditCard,
                            cardId,
                            onSuccess,
                          );
                        },
                      ),
                    );
                  }
                },
                text: store.buttonName(isSelfie: isSelfie, isCard: !isSelfie),
                icon: store.buttonIcon ? const SArrowUpIcon() : const SWhitePhotoIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
