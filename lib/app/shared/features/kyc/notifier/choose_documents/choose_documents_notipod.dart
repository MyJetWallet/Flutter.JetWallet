import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/kyc_operation_status_model.dart';
import 'choose_documents_notifier.dart';
import 'choose_documents_state.dart';

final chooseDocumentsNotipod = StateNotifierProvider.autoDispose.family<
    ChooseDocumentsNotifier, ChooseDocumentsState, List<KycDocumentType>>((
  ref,
  documents,
) {

  final modifyDocuments = <DocumentsModel>[];
  for (var i = 0; i < documents.length; i++) {
    modifyDocuments.add(
      DocumentsModel(
        document: documents[i],
      ),
    );
  }

  return ChooseDocumentsNotifier(
    read: ref.read,
    documents: modifyDocuments,
  );
});
