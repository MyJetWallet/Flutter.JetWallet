import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/choose_documents/choose_documents_notipod.dart';
import '../../../notifier/choose_documents/choose_documents_state.dart';
import '../../../notifier/upload_kyc_documents/upload_kyc_documents_notipod.dart';
import '../../../notifier/upload_kyc_documents/upload_kyc_documents_state.dart';
import '../kyc_selfie/kyc_selfie.dart';
import 'components/create_kyc_banners_list.dart';
import 'components/page_indicator.dart';

class UploadKycDocuments extends HookWidget {
  const UploadKycDocuments({Key? key}) : super(key: key);

  static void push({
    required BuildContext context,
    required DocumentsModel activeDocument,
  }) {
    navigatorPush(
      context,
      const UploadKycDocuments(),
    );
  }

  static void pushReplacement(BuildContext context) {
    navigatorPushReplacement(
      context,
      const UploadKycDocuments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.9);
    final state = useProvider(uploadKycDocumentsNotipod);
    final notifier = useProvider(uploadKycDocumentsNotipod.notifier);
    final imagePicker = useProvider(imagePickerPod);
    final colors = useProvider(sColorPod);
    final loader = useValueNotifier(StackLoaderNotifier());
    final document =
        useProvider(chooseDocumentsNotipod.notifier).getActiveDocument();

    final _banners = createKycBannersList(
      documentFirstSide: state.documentFirstSide,
      documentSecondSide: state.documentSecondSide,
      colors: colors,
      notifier: notifier,
    );

    return ProviderListener<UploadKycDocumentsState>(
      provider: uploadKycDocumentsNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            loader.value.finishLoading();
          },
          done: () {
            SuccessScreen.pushReplacement(
              context: context,
              secondaryText: 'Your document has been uploaded.',
              onSuccess: (context) {
                KycSelfie.pushReplacement(context: context);
              },
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        loading: loader.value,
        header: SPaddingH24(
          child: SSmallHeader(
            title: 'Upload ${stringKycDocumentType(document.document)}',
          ),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                // const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Side ${state.numberSide + 1}',
                      style: sSubtitle2Style,
                    ),
                  ],
                ),
                const SpaceH20(),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (int index) {
                      notifier.changeDocumentSide(index);
                    },
                    itemCount:
                        (document.document != KycDocumentType.passport) ? 2 : 1,
                    itemBuilder: (_, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                        ),
                        child: _banners[index],
                      );
                    },
                  ),
                ),
                const SpaceH18(),
                PageIndicator(
                  documentType: document.document,
                ),
                // const Spacer(),
                const SPaddingH24(
                  child: SDocumentsRecommendations(),
                ),
              ],
            ),
            SFloatingButtonFrame(
              button: SPrimaryButton2(
                onTap: () async {
                  // Todo: need refactor
                  if (document.document != KycDocumentType.passport) {
                    if (state.documentFirstSide == null ||
                        state.documentSecondSide == null) {
                      final file = await imagePicker.pickedFile();
                      if (file != null) {
                        notifier.updateDocumentSide(file);
                      }

                      await _animatePageView(state, controller);
                    } else {
                      // Upload Files
                      loader.value.startLoading();
                      await notifier.uploadDocuments(
                        kycDocumentTypeInt(document.document),
                      );
                    }
                  } else {
                    if (state.documentFirstSide == null) {
                      final file = await imagePicker.pickedFile();
                      if (file != null) {
                        notifier.updateDocumentSide(file);
                      }
                    } else {
                      loader.value.startLoading();
                      await notifier.uploadPassportDocument(
                        kycDocumentTypeInt(document.document),
                      );
                    }
                  }
                },
                name: _buttonName(state, document),
                active: _activeScanButton(state, document),
                icon: (state.documentFirstSide != null &&
                        state.documentSecondSide != null)
                    ? const SArrowUpIcon()
                    : const SWhitePhotoIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _animatePageView(
    UploadKycDocumentsState state,
    PageController controller,
  ) async {
    if (state.numberSide == 0 && state.documentSecondSide != null ||
        state.numberSide == 1 && state.documentFirstSide != null) {
      return;
    }

    if (state.numberSide == 0 && state.documentFirstSide == null) {
      await controller.animateToPage(
        1,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
      );
    }
    if (state.numberSide == 1 && state.documentSecondSide == null) {
      await controller.animateToPage(
        0,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
      );
    }
  }

  bool _activeScanButton(
    UploadKycDocumentsState state,
    DocumentsModel document,
  ) {
    if (document.document == KycDocumentType.passport) {
      return true;
    }

    if (state.documentFirstSide != null && state.documentSecondSide != null) {
      return true;
    }
    if (state.numberSide == 0) {
      if (state.documentFirstSide == null) {
        return true;
      } else {
        return false;
      }
    } else {
      if (state.documentSecondSide == null) {
        return true;
      } else {
        return false;
      }
    }
  }

  String _buttonName(UploadKycDocumentsState state, DocumentsModel document) {
    if (state.numberSide == 0 || state.numberSide == 1) {
      if (document.document != KycDocumentType.passport) {
        if (state.documentFirstSide == null ||
            state.documentSecondSide == null) {
          return 'Scan ${state.numberSide + 1} side';
        } else if (state.documentFirstSide != null &&
            state.documentSecondSide != null) {
          return 'Upload photos';
        }
      } else {
        if (state.documentFirstSide != null) {
          return 'Upload photos';
        } else {
          return 'Scan ${state.numberSide + 1} side';
        }
      }
    }
    return '';
  }
}
