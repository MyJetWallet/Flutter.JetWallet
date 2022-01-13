import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/kyc/helper/convert_kyc_documents.dart';
import 'package:jetwallet/app/shared/features/kyc/notifier/upload_kyc_documents/upload_kyc_documents_union.dart';
import 'package:jetwallet/shared/components/result_screens/success_screen/success_screen.dart';
import 'package:jetwallet/shared/logging/levels.dart';
import 'package:jetwallet/shared/providers/service_providers.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'upload_kyc_documents_state.dart';

class UploadKycDocumentsNotifier
    extends StateNotifier<UploadKycDocumentsState> {
  UploadKycDocumentsNotifier({
    required this.read,
  }) : super(
          const UploadKycDocumentsState(),
        );

  final Reader read;
  static final _logger = Logger('UploadKycDocumentsNotifier');

  void changeDocumentSide(int index) {
    state = state.copyWith(numberSide: index);
  }

  void updateDocumentSide(File file) {
    if (state.numberSide == 0) {
      state = state.copyWith(documentFirstSide: file);
    } else {
      state = state.copyWith(documentSecondSide: file);
    }
  }

  void removeDocumentSide() {
    if (state.numberSide == 0) {
      state = state.copyWith(documentFirstSide: null);
    } else {
      state = state.copyWith(documentSecondSide: null);
    }
  }

  Future<void> uploadDocuments(
    int type,
    BuildContext context,
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final service = read(uploadKycDocumentsPod);

      final formData = await convertKycDocuments(
        state.documentFirstSide!,
        state.documentSecondSide!,
      );

      await service.uploadDocuments(formData, type);

      state = state.copyWith(union: const UploadKycDocumentsUnion.done());
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);
      
      state = state.copyWith(union: UploadKycDocumentsUnion.error(error));
      sShowErrorNotification(
        read(sNotificationQueueNotipod.notifier),
        'Something went wrong. Please try again',
      );
    }
  }
}
