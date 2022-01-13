import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'upload_kyc_documents_union.dart';

part 'upload_kyc_documents_state.freezed.dart';

@freezed
class UploadKycDocumentsState with _$UploadKycDocumentsState {
  const factory UploadKycDocumentsState({
    File? documentFirstSide,
    File? documentSecondSide,
    @Default(0) int numberSide,
    @Default(Input()) UploadKycDocumentsUnion union,
  }) = _UploadKycDocumentsState;

  const UploadKycDocumentsState._();

  bool get activeScanButton {
    if (documentFirstSide != null && documentSecondSide != null) {
      return true;
    }
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

  String get buttonName {
    if (numberSide == 0 || numberSide == 1) {
      if (documentFirstSide == null || documentSecondSide == null) {
        return 'Scan ${numberSide + 1} side';
      } else if (documentFirstSide != null && documentSecondSide != null) {
        return 'Upload photos';
      }
    }
    return '';
  }
}
