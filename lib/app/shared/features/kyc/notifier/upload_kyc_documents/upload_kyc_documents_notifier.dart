import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'upload_kyc_documents_state.dart';

class UploadKycDocumentsNotifier
    extends StateNotifier<UploadKycDocumentsState> {
  UploadKycDocumentsNotifier({
    required this.read,
  }) : super(
          const UploadKycDocumentsState(),
        );

  final Reader read;

  void changeDocumentSide(int index) {
    state = state.copyWith(numberSide: index);
  }

  void updateDocumentSide(File file) {
    if (state.numberSide == 0) {
      state = state.copyWith(documentFirstSide: file);
    } else {
      state = state.copyWith(documentSecondSide: file);
    }
  }
}
