import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/choose_documents/choose_documents_notipod.dart';
import '../allow_camera/allow_camera.dart';
import '../upload_documents/upload_kyc_documents.dart';

class ChooseDocuments extends HookWidget {
  const ChooseDocuments({
    Key? key,
    required this.headerTitle,
    required this.documents,
  }) : super(key: key);

  final String headerTitle;
  final List<KycDocumentType> documents;

  static void pushReplacement({
    required BuildContext context,
    required String headerTitle,
    required List<KycDocumentType> documents,
  }) {
    navigatorPushReplacement(
      context,
      ChooseDocuments(
        headerTitle: headerTitle,
        documents: documents,
      ),
    );
  }

  static void push({
    required BuildContext context,
    required String headerTitle,
    required List<KycDocumentType> documents,
  }) {
    navigatorPush(
      context,
      ChooseDocuments(
        headerTitle: headerTitle,
        documents: documents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(chooseDocumentsNotipod);
    final notifier = useProvider(chooseDocumentsNotipod.notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: headerTitle,
        ),
      ),
      child: Stack(
        children: [
          SPaddingH24(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Baseline(
                            baseline: 24,
                            baselineType: TextBaseline.ideographic,
                            child: Text(
                              'Please scan your document',
                              style: sBodyText1Style,
                            ),
                          ),
                        ],
                      ),
                      const SpaceH20(),
                      for (var index = 0;
                          index < state.documents.length;
                          index++) ...[
                        if (state.documents[index].document !=
                                KycDocumentType.selfieImage &&
                            state.documents[index].document !=
                                KycDocumentType.residentPermit)
                          SChooseDocument(
                            primaryText: stringKycDocumentType(
                              state.documents[index].document,
                            ),
                            activeDocument: state.documents[index].active,
                            onTap: () {
                              notifier.activeDocument(state.documents[index]);
                            },
                          ),
                        const SpaceH10(),
                      ],
                      const Spacer(),
                      const SDocumentsRecommendations(),
                      const SpaceH120(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SFloatingButtonFrame(
            button: SPrimaryButton2(
              onTap: () async {
                final status = await Permission.camera.status;
                if (status == PermissionStatus.granted) {
                  UploadKycDocuments.push(
                    context: context,
                    activeDocument: notifier.getActiveDocument(),
                  );
                } else {
                  AllowCamera.push(
                    context: context,
                    activeDocument: notifier.getActiveDocument(),
                  );
                }
              },
              name: 'Choose document',
              active: notifier.activeButton(),
            ),
          ),
        ],
      ),
    );
  }
}
