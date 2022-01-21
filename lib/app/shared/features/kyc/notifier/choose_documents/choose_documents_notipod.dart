import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../kyc_countries/kyc_countries_notipod.dart';
import 'choose_documents_notifier.dart';
import 'choose_documents_state.dart';

final chooseDocumentsNotipod = StateNotifierProvider.autoDispose<
    ChooseDocumentsNotifier, ChooseDocumentsState>((
  ref,
) {
  final countries = ref.watch(kycCountriesNotipod);

  final modifyDocuments = <DocumentsModel>[];
  for (var i = 0; i < countries.activeCountry.acceptedDocuments.length; i++) {
    modifyDocuments.add(
      DocumentsModel(
        document: countries.activeCountry.acceptedDocuments[i],
      ),
    );
  }

  return ChooseDocumentsNotifier(
    read: ref.read,
    documents: modifyDocuments,
  );
});
