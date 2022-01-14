import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/kyc/view/components/allow_camera/allow_camera.dart';
import 'package:jetwallet/app/shared/features/kyc/view/components/upload_documents/upload_kyc_documents.dart';
import 'package:permission_handler/permission_handler.dart';

import 'choose_documents_state.dart';

class ChooseDocumentsNotifier extends StateNotifier<ChooseDocumentsState> {
  ChooseDocumentsNotifier({
    required this.read,
    required this.documents,
  }) : super(
          const ChooseDocumentsState(),
        ) {
    state = state.copyWith(documents: documents);
  }

  final Reader read;
  final List<DocumentsModel> documents;

  void activeDocument(DocumentsModel document) {
    final test = state.documents.firstWhere((element) => element == document);
    final index = state.documents.indexOf(test);

    final list = List.of(state.documents);
    for (var i = 0; i < list.length; i++) {
      list[i] = DocumentsModel(
        document: list[i].document,
        active: false,
      );
    }
    list[index] = DocumentsModel(
      document: document.document,
      active: true,
    );
    state = state.copyWith(documents: list);
  }

  DocumentsModel getActiveDocument() {
    return state.documents.firstWhere((element) => element.active);
  }

  bool activeButton() {
    final document = state.documents.where((element) => element.active);
    return document.isNotEmpty;
  }
}
