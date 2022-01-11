import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../model/kyc_operation_status_model.dart';

class ChooseDocuments extends StatelessWidget {
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
    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: headerTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Baseline(
                baseline: 24,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  'Please scan your document',
                  style: sBodyText1Style,
                ),
              ),
            ],
          ),
          const SpaceH20(),

          for(var index = 0; index < documents.length; index++) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(

              ),
            ),
            Text(stringKycDocumentType(documents[index])),
          ],
        ],
      ),
    );
  }
}
