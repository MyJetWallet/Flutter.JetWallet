import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../notifier/choose_documents/choose_documents_state.dart';

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
    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Upload ${activeDocument.document.name}',
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 24,
          top: 40,
          left: 24,
          right: 24,
        ),
        child: SPrimaryButton2(
          onTap: () {},
          name: 'Scan 1 side',
          active: true,
          icon: const SWhitePhotoIcon(),
        ),
      ),
      child: Column(
        children: const[
          Spacer(),
          SPaddingH24(
            child: SDocumentsRecommendations(),
          ),
        ],
      ),
    );
  }
}
