import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/store/upload_kyc_documents_store.dart';
import 'package:simple_kit/simple_kit.dart';

class PageIndicator extends StatelessObserverWidget {
  const PageIndicator({
    super.key,
    required this.documentType,
  });

  final KycDocumentType? documentType;

  @override
  Widget build(BuildContext context) {
    final state = UploadKycDocumentsStore.of(context);
    final colors = sKit.colors;

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
