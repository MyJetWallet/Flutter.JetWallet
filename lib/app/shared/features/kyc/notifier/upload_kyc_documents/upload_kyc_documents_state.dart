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
}

@freezed
class UploadKycDocument with _$UploadKycDocument {
  const factory UploadKycDocument({
    File? documentFirstSide,
    File? documentSecondSide,
  }) = _UploadKycDocument;
}
