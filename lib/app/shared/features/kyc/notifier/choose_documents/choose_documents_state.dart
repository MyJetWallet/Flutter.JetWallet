import 'package:freezed_annotation/freezed_annotation.dart';
import '../../model/kyc_operation_status_model.dart';

part 'choose_documents_state.freezed.dart';

@freezed
class ChooseDocumentsState with _$ChooseDocumentsState {
  const factory ChooseDocumentsState({
    @Default([]) List<DocumentsModel> documents,
  }) = _ChooseDocumentsState;
}

@freezed
class DocumentsModel with _$DocumentsModel {
  const factory DocumentsModel({
    @Default(false) bool active,
    required KycDocumentType document,
  }) = _DocumentsModel;
}
