import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/kyc_country_store.dart';
import 'package:jetwallet/features/kyc/models/documents_model.dart';
import 'package:mobx/mobx.dart';

part 'choose_documents_store.g.dart';

@lazySingleton
class ChooseDocumentsStore = _ChooseDocumentsStoreBase with _$ChooseDocumentsStore;

abstract class _ChooseDocumentsStoreBase with Store {
  _ChooseDocumentsStoreBase() {
    init();
  }

  @observable
  ObservableList<DocumentsModel> documents = ObservableList.of([]);

  @action
  void init() {
    final countries = getIt.get<KycCountryStore>();

    final modifyDocuments = <DocumentsModel>[];
    for (var i = 0; i < countries.activeCountry!.acceptedDocuments.length; i++) {
      modifyDocuments.add(
        DocumentsModel(
          document: countries.activeCountry!.acceptedDocuments[i],
        ),
      );
    }

    if (documents.isNotEmpty) {
      _setActiveDocumentIfExist(modifyDocuments);
    }

    documents = ObservableList.of(modifyDocuments);
  }

  @action
  void activeDocument(DocumentsModel document) {
    final findDocument = documents.firstWhere((element) => element == document);
    final index = documents.indexOf(findDocument);

    final list = List.of(documents);
    for (var i = 0; i < list.length; i++) {
      list[i] = DocumentsModel(
        document: list[i].document,
      );
    }
    list[index] = DocumentsModel(
      document: document.document,
      active: true,
    );

    documents = ObservableList.of(list);
  }

  @action
  DocumentsModel? getActiveDocument() {
    final docs = documents.where((element) => element.active);

    return docs.isNotEmpty ? docs.first : null;
  }

  @action
  bool activeButton() {
    final document = documents.where((element) => element.active);

    return document.isNotEmpty;
  }

  @action
  void _setActiveDocumentIfExist(List<DocumentsModel> documents) {
    final activeDocument = <DocumentsModel>[];

    for (final element in documents) {
      if (element.active) {
        activeDocument.add(element);

        return;
      }
    }

    if (activeDocument.isNotEmpty) {
      final index = documents.indexOf(activeDocument[0]);
      documents[index] = DocumentsModel(
        document: activeDocument[0].document,
        active: true,
      );
    }
  }

  @action
  void updateDocuments() {
    final countries = getIt.get<KycCountryStore>();

    final docs = <DocumentsModel>[];

    for (final document in countries.activeCountry!.acceptedDocuments) {
      docs.add(
        DocumentsModel(document: document),
      );
    }

    documents = ObservableList.of(docs);
  }
}
