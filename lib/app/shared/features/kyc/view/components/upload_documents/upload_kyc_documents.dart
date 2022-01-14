import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/choose_documents/choose_documents_state.dart';
import '../../../notifier/upload_kyc_documents/upload_kyc_documents_notipod.dart';
import '../../../notifier/upload_kyc_documents/upload_kyc_documents_state.dart';
import '../kyc_selfie/kyc_selfie.dart';
import 'components/create_kyc_banners_list.dart';
import 'components/page_indicator.dart';

class UploadKycDocuments extends HookWidget {
  const UploadKycDocuments({
    Key? key,
    required this.activeDocument,
  }) : super(key: key);

  final DocumentsModel activeDocument;

  static void push({
    required BuildContext context,
    required DocumentsModel activeDocument,
  }) {
    navigatorPush(
      context,
      UploadKycDocuments(
        activeDocument: activeDocument,
      ),
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required DocumentsModel activeDocument,
  }) {
    navigatorPushReplacement(
      context,
      UploadKycDocuments(
        activeDocument: activeDocument,
      ),
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
            SuccessScreen.push(
              context: context,
              secondaryText: 'Your document has been uploaded.',
              then: () {
                navigatorPush(
                  context,
                  const KycSelfie(),
                );
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
            title: 'Upload ${activeDocument.document.name}',
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Side ${state.numberSide + 1}',
              style: sSubtitle2Style,
            ),
            const SpaceH20(),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: controller,
                onPageChanged: (int index) {
                  notifier.changeDocumentSide(index);
                },
                itemCount: 2,
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
            const PageIndicator(),
            const Spacer(),
            const SPaddingH24(
              child: SDocumentsRecommendations(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 24.0,
                top: 40.0,
                left: 24.0,
                right: 24.0,
              ),
              child: SPrimaryButton2(
                onTap: () async {
                  if (state.documentFirstSide == null ||
                      state.documentSecondSide == null) {
                    final file = await imagePicker.pickedFile();
                    if (file != null) {
                      notifier.updateDocumentSide(file);
                    }
                  } else {
                    // Upload Files
                    loader.value.startLoading();
                    await notifier.uploadDocuments(
                      kycDocumentTypeInt(activeDocument.document),
                    );
                  }
                },
                name: state.buttonName,
                active: state.activeScanButton,
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
}
