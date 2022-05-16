import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../helper/convert_kyc_documents.dart';
import '../../model/kyc_operation_status_model.dart';
import '../choose_documents/choose_documents_notipod.dart';
import 'upload_kyc_documents_state.dart';
import 'upload_kyc_documents_union.dart';

class UploadKycDocumentsNotifier
    extends StateNotifier<UploadKycDocumentsState> {
  UploadKycDocumentsNotifier({
    required this.read,
  }) : super(
          UploadKycDocumentsState(
            pageViewController: PageController(viewportFraction: 0.9),
          ),
        );

  final Reader read;
  static final _logger = Logger('UploadKycDocumentsNotifier');

  void changeDocumentSide(int index) {
    state = state.copyWith(numberSide: index);
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
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final service = read(kycDocumentsServicePod);

      final formData = await convertKycDocuments(
        state.documentFirstSide,
        state.documentSecondSide,
        read,
      );

      await service.upload(formData, type);

      state = state.copyWith(union: const UploadKycDocumentsUnion.done());
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      final intl = read(intlPod);

      sAnalytics.kycIdentityUploadFailed(error.toString());
      state = state.copyWith(union: UploadKycDocumentsUnion.error(error));
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong2,
        id: 1,
      );
    }
  }

  Future<void> documentPageViewLogic(
    KycDocumentType document,
    ValueNotifier<StackLoaderNotifier> loader,
  ) async {
    _logger.log(notifier, 'documentPageViewLogic');

    if (document != KycDocumentType.passport) {
      if (state.documentFirstSide == null || state.documentSecondSide == null) {
        await _pickFile(true);
      } else {
        loader.value.startLoading();
        sAnalytics.kycIdentityUploaded();
        await uploadDocuments(
          kycDocumentTypeInt(document),
        );
      }
    } else {
      if (state.documentFirstSide == null) {
        await _pickFile(false);
      } else {
        loader.value.startLoading();
        sAnalytics.kycIdentityUploaded();
        await _uploadPassportDocument(
          kycDocumentTypeInt(document),
        );
      }
    }
  }

  Future<void> _uploadPassportDocument(
    int type,
  ) async {
    _logger.log(notifier, 'uploadPassportDocument');

    try {
      final service = read(kycDocumentsServicePod);

      final formData = await convertKycDocuments(
        state.documentFirstSide,
        null,
        read,
      );

      await service.upload(formData, type);

      state = state.copyWith(union: const UploadKycDocumentsUnion.done());
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      final intl = read(intlPod);

      sAnalytics.kycIdentityUploadFailed(error.toString());
      state = state.copyWith(union: UploadKycDocumentsUnion.error(error));
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong2,
        id: 1,
      );
    }
  }

  bool activeScanButton() {
    _logger.log(notifier, 'activeScanButton');

    final activeDocument =
        read(chooseDocumentsNotipod.notifier).getActiveDocument();

    if (activeDocument.document == KycDocumentType.passport) {
      return activeScanButtonType(ActiveScanButton.active);
    }

    if (state.documentFirstSide != null && state.documentSecondSide != null) {
      return activeScanButtonType(ActiveScanButton.active);
    }

    if (state.numberSide == 0) {
      if (state.documentFirstSide == null) {
        return activeScanButtonType(ActiveScanButton.active);
      } else {
        return activeScanButtonType(ActiveScanButton.notActive);
      }
    } else {
      if (state.documentSecondSide == null) {
        return activeScanButtonType(ActiveScanButton.active);
      } else {
        return activeScanButtonType(ActiveScanButton.notActive);
      }
    }
  }

  Future<void> _pickFile(bool isAnimatePageView) async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      _updateDocumentSide(File(file.path));
      if (isAnimatePageView) await _animatePageView(state.pageViewController);
    }
  }

  Future<void> _animatePageView(
    PageController controller,
  ) async {
    if (state.numberSide == 0 && state.documentSecondSide == null ||
        state.numberSide == 1 && state.documentFirstSide == null) {
      await controller.animateToPage(
        (state.numberSide == 0) ? 1 : 0,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
      );
    }
  }

  void _updateDocumentSide(File file) {
    if (state.numberSide == 0) {
      state = state.copyWith(documentFirstSide: file);
    } else {
      state = state.copyWith(documentSecondSide: file);
    }
  }

  String buttonName() {
    final activeDocument =
        read(chooseDocumentsNotipod.notifier).getActiveDocument();
    final intl = read(intlPod);

    if (activeDocument.document != KycDocumentType.passport) {
      if (state.documentFirstSide != null && state.documentSecondSide != null) {
        return intl.uploadPhotos;
      } else {
        if (state.numberSide == 0) {
          return intl.frontSide;
        } else {
          return intl.backSide;
        }
      }
    } else {
      if (state.documentFirstSide != null) {
        return intl.uploadPhotos;
      } else {
        return intl.frontSide;
      }
    }
  }
}
