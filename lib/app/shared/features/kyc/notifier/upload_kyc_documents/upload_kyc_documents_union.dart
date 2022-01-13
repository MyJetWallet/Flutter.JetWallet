import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_kyc_documents_union.freezed.dart';

@freezed
class UploadKycDocumentsUnion with _$UploadKycDocumentsUnion {
  const factory UploadKycDocumentsUnion.input() = Input;
  const factory UploadKycDocumentsUnion.error(Object error) = Error;
  const factory UploadKycDocumentsUnion.done() = Done;
}