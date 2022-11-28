import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';

part 'documents_model.freezed.dart';

@freezed
class DocumentsModel with _$DocumentsModel {
  const factory DocumentsModel({
    @Default(false) bool active,
    required KycDocumentType document,
  }) = _DocumentsModel;
}
