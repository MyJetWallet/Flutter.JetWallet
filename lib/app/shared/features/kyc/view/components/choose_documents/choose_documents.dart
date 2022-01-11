import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../model/kyc_operation_status_model.dart';
import '../../../notifier/choose_documents/choose_documents_notipod.dart';

class ChooseDocuments extends HookWidget {
  const ChooseDocuments({
    Key? key,
    required this.headerTitle,
    required this.documents,
  }) : super(key: key);

  final String headerTitle;
  final List<KycDocumentType> documents;

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
    final state = useProvider(chooseDocumentsNotipod(documents));
    final notifier = useProvider(chooseDocumentsNotipod(documents).notifier);

    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: headerTitle,
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
          name: 'Choose document',
          active: notifier.activeButton(),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
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
                      KycDocumentType.selfieImage)
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
