import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetwallet/app/shared/features/kyc/view/components/upload_documents/components/page_indicator.dart';
import 'package:jetwallet/shared/providers/service_providers.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../notifier/choose_documents/choose_documents_state.dart';
import '../../../notifier/upload_kyc_documents/upload_kyc_documents_notipod.dart';
import 'components/skeleton_first_side.dart';

class UploadKycDocuments extends HookWidget {
  const UploadKycDocuments({
    Key? key,
    required this.activeDocument,
  }) : super(key: key);

  final DocumentsModel activeDocument;

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

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Upload ${activeDocument.document.name}',
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 24.0,
          top: 40.0,
          left: 24.0,
          right: 24.0,
        ),
        child: SPrimaryButton2(
          onTap: () async {
            final file = await imagePicker.pickedFile();
            if (file != null) {
              notifier.updateDocumentSide(file);
            }
          },
          name: 'Scan ${state.numberSide + 1} side',
          active: state.activeScanButton,
          icon: const SWhitePhotoIcon(),
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
                  child: const SkeletonFirstSide(),
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
        ],
      ),
    );
  }
}
