import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../model/kyc_operation_status_model.dart';
import '../../../../notifier/upload_kyc_documents/upload_kyc_documents_notipod.dart';

class PageIndicator extends HookWidget {
  const PageIndicator({
    Key? key,
    required this.documentType,
  }) : super(key: key);

  final KycDocumentType documentType;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(uploadKycDocumentsNotipod);
    final colors = useProvider(sColorPod);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 2,
          color: state.numberSide == 0
              ? colors.black
              : colors.black.withOpacity(0.3),
        ),
        if (documentType != KycDocumentType.passport) ...[
          const SpaceW4(),
          Container(
            width: 24,
            height: 2,
            color: state.numberSide == 1
                ? colors.black
                : colors.black.withOpacity(0.3),
          ),
        ],
      ],
    );
  }
}
