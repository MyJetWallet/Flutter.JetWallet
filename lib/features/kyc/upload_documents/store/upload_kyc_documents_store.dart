import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/choose_documents_store.dart';
import 'package:jetwallet/features/kyc/helper/convert_kyc_documents.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/upload_documents/models/upload_kyc_documents_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:universal_io/io.dart';

part 'upload_kyc_documents_store.g.dart';

class UploadKycDocumentsStore extends _UploadKycDocumentsStoreBase
    with _$UploadKycDocumentsStore {
  UploadKycDocumentsStore() : super();

  static UploadKycDocumentsStore of(BuildContext context) =>
      Provider.of<UploadKycDocumentsStore>(context, listen: false);
}

abstract class _UploadKycDocumentsStoreBase with Store {
  _UploadKycDocumentsStoreBase();

  static final _logger = Logger('UploadKycDocumentsStore');

  @observable
  File? documentFirstSide;

  @observable
  File? documentSecondSide;

  @observable
  int numberSide = 0;

  @observable
  UploadKycDocumentsUnion union = const UploadKycDocumentsUnion.input();

  PageController pageViewController = PageController(viewportFraction: 0.9);

  @computed
  bool get getActiveScanButton {
    if (documentFirstSide != null && documentSecondSide != null) {
      return true;
    }

    return numberSide == 0
        ? documentFirstSide == null
        : documentSecondSide == null;
  }

  @computed
  bool get buttonIcon {
    return documentFirstSide != null && documentSecondSide != null;
  }

  @action
  void changeDocumentSide(int index) {
    numberSide = index;
  }

  @action
  void removeDocumentSide() {
    numberSide == 0 ? documentFirstSide = null : documentSecondSide = null;
  }

  @action
  Future<void> uploadDocuments(
    int type,
  ) async {
    _logger.log(notifier, 'uploadDocuments');

    try {
      final formData = await convertKycDocuments(
        documentFirstSide,
        documentSecondSide,
      );

      final response = await sNetwork.getWalletModule().postUploadDocuments(
            formData,
            type,
          );

      response.pick(
        onNoData: () {
          union = const UploadKycDocumentsUnion.done();
        },
        onNoError: (data) {
          union = const UploadKycDocumentsUnion.done();
        },
        onData: (data) {
          union = const UploadKycDocumentsUnion.done();
        },
        onError: (error) {
          sAnalytics.kycIdentityUploadFailed(error.toString());

          sNotification.showError(
            intl.something_went_wrong_try_again,
            id: 1,
          );
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      sAnalytics.kycIdentityUploadFailed(error.toString());

      union = UploadKycDocumentsUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    }
  }

  @action
  Future<void> documentPageViewLogic(
    KycDocumentType document,
    StackLoaderStore loader,
  ) async {
    _logger.log(notifier, 'documentPageViewLogic');

    if (document != KycDocumentType.passport) {
      if (documentFirstSide == null || documentSecondSide == null) {
        await _pickFile(true);
      } else {
        loader.startLoading();
        sAnalytics.kycIdentityUploaded();
        await uploadDocuments(
          kycDocumentTypeInt(document),
        );
      }
    } else {
      if (documentFirstSide == null) {
        await _pickFile(false);
      } else {
        loader.startLoading();
        sAnalytics.kycIdentityUploaded();
        await _uploadPassportDocument(
          kycDocumentTypeInt(document),
        );
      }
    }
  }

  @action
  Future<void> _uploadPassportDocument(
    int type,
  ) async {
    _logger.log(notifier, 'uploadPassportDocument');

    try {
      final formData = await convertKycDocuments(
        documentFirstSide,
        null,
      );

      final response = await sNetwork.getWalletModule().postUploadDocuments(
            formData,
            type,
          );

      response.pick(
        onNoData: () {
          union = const UploadKycDocumentsUnion.done();
        },
        onNoError: (data) {
          union = const UploadKycDocumentsUnion.done();
        },
        onData: (data) {
          union = const UploadKycDocumentsUnion.done();
        },
        onError: (error) {
          sAnalytics.kycIdentityUploadFailed(error.toString());

          sNotification.showError(
            intl.something_went_wrong_try_again,
            id: 1,
          );
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'uploadDocuments', error);

      sAnalytics.kycIdentityUploadFailed(error.toString());

      union = UploadKycDocumentsUnion.error(error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    }
  }

  @action
  bool activeScanButton() {
    _logger.log(notifier, 'activeScanButton');

    final activeDocument =
        getIt.get<ChooseDocumentsStore>().getActiveDocument();

    if (activeDocument.document == KycDocumentType.passport) {
      return activeScanButtonType(ActiveScanButton.active);
    }

    if (documentFirstSide != null && documentSecondSide != null) {
      return activeScanButtonType(ActiveScanButton.active);
    }

    return numberSide == 0
        ? documentFirstSide == null
            ? activeScanButtonType(ActiveScanButton.active)
            : activeScanButtonType(ActiveScanButton.notActive)
        : documentSecondSide == null
            ? activeScanButtonType(ActiveScanButton.active)
            : activeScanButtonType(ActiveScanButton.notActive);
  }

  @action
  Future<void> _pickFile(bool isAnimatePageView) async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      _updateDocumentSide(File(file.path));
      if (isAnimatePageView) await _animatePageView(pageViewController);
    }
  }

  @action
  Future<void> _animatePageView(
    PageController controller,
  ) async {
    if (numberSide == 0 && documentSecondSide == null ||
        numberSide == 1 && documentFirstSide == null) {
      await controller.animateToPage(
        (numberSide == 0) ? 1 : 0,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
      );
    }
  }

  @action
  void _updateDocumentSide(File file) {
    if (numberSide == 0) {
      documentFirstSide = file;
    } else {
      documentSecondSide = file;
    }
  }

  @action
  String buttonName() {
    final activeDocument =
        getIt.get<ChooseDocumentsStore>().getActiveDocument();

    return activeDocument.document != KycDocumentType.passport
        ? documentFirstSide != null && documentSecondSide != null
            ? intl.uploadKycDocuments_uploadPhotos
            : numberSide == 0
                ? intl.uploadKycDocuments_frontSide
                : intl.uploadKycDocuments_backSide
        : documentFirstSide != null
            ? intl.uploadKycDocuments_uploadPhotos
            : intl.uploadKycDocuments_frontSide;
  }
}
