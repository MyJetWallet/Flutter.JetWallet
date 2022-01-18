import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../kyc/kyc_notipod.dart';
import 'choose_documents_notifier.dart';
import 'choose_documents_state.dart';

final chooseDocumentsNotipod = StateNotifierProvider.autoDispose<
    ChooseDocumentsNotifier, ChooseDocumentsState>((
  ref,
) {
  final kycN = ref.read(kycNotipod.notifier);

  final modifyDocuments = <DocumentsModel>[];
  for (var i = 0; i < kycN.kycModel.requiredDocuments.length; i++) {
    modifyDocuments.add(
      DocumentsModel(
        document: kycN.kycModel.requiredDocuments[i],
      ),
    );
  }

  return ChooseDocumentsNotifier(
    read: ref.read,
    documents: modifyDocuments,
  );
});
