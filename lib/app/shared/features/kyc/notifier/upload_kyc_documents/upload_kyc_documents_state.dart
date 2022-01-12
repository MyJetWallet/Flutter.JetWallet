import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_kyc_documents_state.freezed.dart';

@freezed
class UploadKycDocumentsState with _$UploadKycDocumentsState {
  const factory UploadKycDocumentsState({
    File? documentFirstSide,
    File? documentSecondSide,
    @Default(0) int numberSide,
  }) = _UploadKycDocumentsState;

  const UploadKycDocumentsState._();

  bool get activeScanButton {
    if (numberSide == 0) {
      if (documentFirstSide == null) {
        return true;
      } else {
        return false;
      }
    } else {
      if (documentSecondSide == null) {
        return true;
      } else {
        return false;
      }
    }
  }
}
