import 'dart:io';

import 'package:flutter/material.dart';
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
    required PageController pageViewController,
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

  bool get buttonIcon {
    return documentFirstSide != null && documentSecondSide != null;
  }
}
